module Page.Quest.List exposing (Model, Msg, init, update, view)

import Api exposing (Cred)
import Api.Endpoint as Endpoint
import Completion exposing (Completion)
import Element exposing (Element, centerX, centerY, column, el, fill, height, maximum, paddingXY, pointer, px, rgb255, rgba255, row, scrollbarY, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input exposing (placeholder)
import Html
import Html.Events
import Http
import Json.Decode as Decode
import Material.Dialog exposing (dialog)
import Material.Elevation as Elevation
import Material.Fab as Fab
import Material.Icons as Icons
import Process
import Quest exposing (Quest)
import RemoteData exposing (WebData)
import Route exposing (Route)
import Task
import Theme exposing (Theme)


type alias Model =
    { cred : Cred
    , theme : Theme
    , searchText : String
    , questList : WebData (List Quest)
    , completions : WebData (List Completion)
    , dialog : Dialog
    , snackbar : Snackbar
    , menuOpen : Bool
    }


type Dialog
    = Closed
    | Open { title : String, moreInfo : String }


type alias Snackbar =
    { removing : Bool
    , messages : List String
    }


type Msg
    = CloseDialog
    | GotQuestCompletions (WebData (List Completion))
    | GotQuestCompletionResponse (WebData String)
    | GotQuests (WebData (List Quest))
    | MenuClosed
    | MenuToggled
    | OpenDialog String String
    | QuestClicked String
    | SnackbarHid
    | SnackbarHidRequested
    | UpdateSearch String


init : Maybe String -> Cred -> Theme -> ( Model, Cmd Msg )
init snackbarTxt cred theme =
    ( { cred = cred
      , theme = theme
      , searchText = ""
      , questList = RemoteData.NotAsked
      , completions = RemoteData.NotAsked
      , dialog = Closed
      , snackbar = initSnackbar snackbarTxt
      , menuOpen = False
      }
    , Cmd.batch
        [ request cred
        , request2 cred
        , case snackbarTxt of
            Just _ ->
                delay 5000 SnackbarHid

            Nothing ->
                Cmd.none
        ]
    )


questCompletionCount : Model -> Int
questCompletionCount model =
    case model.completions of
        RemoteData.Success completionList ->
            List.length completionList

        _ ->
            0


initSnackbar : Maybe String -> Snackbar
initSnackbar snackbarTxt =
    case snackbarTxt of
        Just text ->
            { removing = False
            , messages = [ text ]
            }

        Nothing ->
            { removing = False
            , messages = []
            }


delay : Float -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.perform (\_ -> msg)


request : Cred -> Cmd Msg
request cred =
    Api.get Endpoint.quests (Just cred) GotQuests Quest.decoder


request2 : Cred -> Cmd Msg
request2 cred =
    Api.get Endpoint.completedToday (Just cred) GotQuestCompletions Completion.decoder


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CloseDialog ->
            ( { model | dialog = Closed }, Cmd.none )

        GotQuestCompletions response ->
            ( { model | completions = response }, Cmd.none )

        GotQuestCompletionResponse response ->
            case response of
                RemoteData.Success _ ->
                    let
                        snackbarModel =
                            model.snackbar

                        newSnackbar =
                            { snackbarModel | messages = List.append snackbarModel.messages [ "Completed quest." ] }
                    in
                    update SnackbarHidRequested { model | snackbar = newSnackbar }

                _ ->
                    let
                        snackbarModel =
                            model.snackbar

                        newSnackbar =
                            { snackbarModel | messages = List.append snackbarModel.messages [ "Something went wrong." ] }
                    in
                    update SnackbarHidRequested { model | snackbar = newSnackbar }

        GotQuests response ->
            ( { model | questList = response }, Cmd.none )

        MenuClosed ->
            ( { model | menuOpen = False }, Cmd.none )

        MenuToggled ->
            ( { model | menuOpen = not model.menuOpen }, Cmd.none )

        OpenDialog title moreInfo ->
            ( { model | dialog = Open { title = title, moreInfo = moreInfo } }, Cmd.none )

        QuestClicked title ->
            ( model, Api.get (Endpoint.complete title) (Just model.cred) GotQuestCompletionResponse Decode.string )

        SnackbarHid ->
            let
                ( removing, cmd ) =
                    case List.drop 1 model.snackbar.messages of
                        [] ->
                            ( False, Cmd.none )

                        _ ->
                            ( True, delay 5000 SnackbarHid )

                snackbarModel =
                    model.snackbar

                newSnackbar =
                    { snackbarModel | removing = removing, messages = List.drop 1 snackbarModel.messages }
            in
            ( { model | snackbar = newSnackbar }, cmd )

        SnackbarHidRequested ->
            if model.snackbar.removing then
                ( model, Cmd.none )

            else
                let
                    snackbarModel =
                        model.snackbar

                    newSnackbar =
                        { snackbarModel | removing = True }
                in
                ( { model | snackbar = newSnackbar }, delay 5000 SnackbarHid )

        UpdateSearch text ->
            ( { model | searchText = text }, Cmd.none )


sort : List Quest -> List ( String, List Quest )
sort quests =
    let
        duplicateItemList =
            List.map toItem quests
    in
    List.foldr foldFunction [] duplicateItemList


filter : String -> Quest -> Bool
filter text quest =
    if String.contains text quest.title then
        True

    else if String.contains text quest.description then
        True

    else if String.contains text quest.category then
        True

    else if String.contains text quest.timeEstimate then
        True

    else
        String.contains text quest.moreInfo


toItem : Quest -> ( String, Quest )
toItem quest =
    ( quest.category, quest )


foldFunction : ( String, Quest ) -> List ( String, List Quest ) -> List ( String, List Quest )
foldFunction ( category, quest ) sortedItems =
    case List.head <| List.filter (isSameCategory category) sortedItems of
        Nothing ->
            ( category, [ quest ] ) :: sortedItems

        Just ( itemCategory, questList ) ->
            ( itemCategory, quest :: questList ) :: List.filter (isNotSameCategory category) sortedItems


isSameCategory : String -> ( String, List Quest ) -> Bool
isSameCategory category ( itemCategory, _ ) =
    category == itemCategory


isNotSameCategory : String -> ( String, List Quest ) -> Bool
isNotSameCategory category ( itemCategory, _ ) =
    category /= itemCategory



-- view


view : Model -> Element Msg
view model =
    column
        [ width fill
        , height fill
        , Element.onRight <| fab model.theme
        , Element.inFront <|
            case model.dialog of
                Open { title, moreInfo } ->
                    dialog model.theme CloseDialog title moreInfo

                Closed ->
                    Element.none
        , Element.inFront <|
            case model.snackbar.messages of
                txt :: _ ->
                    snackbar txt

                _ ->
                    Element.none
        , if model.menuOpen then
            onClick MenuClosed

          else
            Element.inFront Element.none
        ]
        [ topAppBar model
        , column
            [ width <| maximum 1200 fill
            , height fill
            , centerX
            , scrollbarY
            , Element.paddingEach
                { top = 0
                , right = 0
                , bottom = 72
                , left = 0
                }
            ]
          <|
            data model
        ]


snackbar : String -> Element msg
snackbar txt =
    column
        [ Element.alignBottom
        , width fill
        , paddingXY 8 80
        ]
        [ row
            [ width fill
            , height (px 48)
            , Elevation.z5
            , Background.color (rgba255 51 51 51 1)
            , Font.color (rgba255 255 240 240 1)
            , Font.semiBold
            , Font.size 14
            , Border.rounded 4
            , paddingXY 14 16
            ]
            [ text txt ]
        ]


data : Model -> List (Element Msg)
data model =
    case model.questList of
        RemoteData.NotAsked ->
            [ text "You didnt ask me so i will do nothing" ]

        RemoteData.Loading ->
            [ text "Loading..." ]

        RemoteData.Success quests ->
            if String.isEmpty model.searchText then
                [ column
                    [ Element.paddingEach
                        { top = 0
                        , right = 0
                        , bottom = 80
                        , left = 0
                        }
                    ]
                  <|
                    List.map (list model.theme) (sort quests)
                ]

            else
                [ column
                    [ Element.paddingEach
                        { top = 0
                        , right = 0
                        , bottom = 80
                        , left = 0
                        }
                    ]
                  <|
                    List.map (list model.theme) (sort <| List.filter (filter model.searchText) quests)
                ]

        RemoteData.Failure error ->
            case error of
                Http.BadBody explanation ->
                    [ text <| "The server responded with something unexpected. Reason: " ++ explanation ]

                Http.BadUrl _ ->
                    [ text "Invalid url" ]

                Http.BadStatus statusCode ->
                    [ text <| "Request failed with status code: " ++ String.fromInt statusCode ]

                Http.NetworkError ->
                    [ text "Unable to reach server." ]

                Http.Timeout ->
                    [ text "Server is taking too long to respond. Please try again later." ]


topAppBar : Model -> Element Msg
topAppBar model =
    column [ width fill, Elevation.z2 ]
        [ topAppBarRow model.theme [] [ input model ]
        , topAppBarRow model.theme
            []
            [ column [ spacing 2 ]
                [ text "Quests"
                , Element.el
                    [ Font.size 13
                    , Font.color (Element.rgba255 255 255 255 0.76)
                    ]
                    (text <| (String.fromInt <| questCompletionCount model) ++ "/1 completed today")
                ]
            ]
        ]


topAppBarRow : Theme -> List (Element.Attribute msg) -> List (Element msg) -> Element msg
topAppBarRow theme attributes elements =
    row
        (List.append
            attributes
            [ width fill
            , height (px 64)
            , Background.color theme.primary
            , Font.color theme.onPrimary
            , Font.size 20
            , Element.paddingXY 16 0
            ]
        )
        elements


input : Model -> Element Msg
input model =
    row
        [ height (px 48)
        , width fill
        , Border.rounded 4
        , Border.width 0
        , Background.color (rgb255 255 255 255)
        , Element.paddingXY 16 0
        , spacing 24
        ]
        [ Element.el [ Font.color (rgba255 0 0 0 0.54) ] Icons.search
        , Input.text
            [ Font.size 16
            , Font.light
            , Font.color (rgba255 0 0 0 0.87)
            , Border.width 0
            , Background.color (rgba255 0 0 0 0)
            ]
            { onChange = UpdateSearch
            , text = model.searchText
            , placeholder = Just <| placeholder [ Font.color <| rgba255 0 0 0 0.38 ] (text "Search quests")
            , label = Input.labelHidden ""
            }
        , Element.el
            [ Font.color (rgba255 0 0 0 0.54)
            , pointer
            , onClick MenuToggled
            , if model.menuOpen then
                Element.below <| menu model.theme

              else
                Element.below Element.none
            ]
            Icons.account_circle
        ]



-- List


list : Theme -> ( String, List Quest ) -> Element Msg
list theme ( category, quests ) =
    column
        [ width fill
        , paddingXY 0 8
        ]
        [ listDividerTitle theme category
        , threeLine theme quests
        ]


listDividerTitle : Theme -> String -> Element msg
listDividerTitle theme category =
    el
        [ height (px 48)
        , Element.paddingXY 16 0
        ]
    <|
        el
            [ Font.size 14
            , Font.color <| Theme.highlight theme.kind 0.54
            , Font.bold
            , centerY
            ]
        <|
            text category


icon : Theme -> List (Element.Attribute msg) -> Element msg -> Element msg
icon theme attrs icon_ =
    el
        (List.append
            [ height (px 40)
            , width (px 40)
            , Font.color <| Theme.highlight theme.kind 0.44
            , Background.color (Theme.highlight theme.kind 0.1)
            , Border.rounded 50
            , Element.clip
            ]
            attrs
        )
    <|
        el
            [ centerY
            , centerX
            ]
            icon_


threeLine : Theme -> List Quest -> Element Msg
threeLine theme quests =
    column
        [ width fill
        , Font.color theme.onBackground
        , Element.paddingEach
            { bottom = 8
            , left = 16
            , right = 0
            , top = 8
            }
        ]
    <|
        List.map (threeElement theme) quests


onClickNoBubble : msg -> Html.Attribute msg
onClickNoBubble message =
    Html.Events.custom "click" (Decode.succeed { message = message, stopPropagation = True, preventDefault = True })


threeElement : Theme -> Quest -> Element Msg
threeElement theme quest =
    row
        [ width fill
        , spacing 32
        , pointer
        ]
        [ icon theme [] Icons.check
        , row
            [ width fill
            , height (px 88)
            , Element.spacingXY 0 4
            , Border.widthEach
                { bottom = 1
                , left = 0
                , right = 0
                , top = 0
                }
            , Border.color <| Theme.highlight theme.kind 0.12
            , spacing 8
            , onClick <| QuestClicked quest.title
            ]
            [ column
                [ width fill, spacing 4 ]
                [ row
                    [ width fill
                    , Font.size 16
                    , centerY
                    ]
                    [ el
                        [ Element.centerY
                        ]
                      <|
                        Element.text quest.title
                    ]
                , row
                    [ width fill
                    , Font.size 14
                    , Font.color <| Theme.highlight theme.kind 0.54
                    , centerY
                    ]
                    [ el
                        [ Element.centerY
                        , width fill
                        ]
                      <|
                        Element.paragraph [ width fill ]
                            [ Element.text quest.description ]
                    ]
                ]
            , column
                [ height fill
                , Element.paddingEach
                    { bottom = 8
                    , left = 0
                    , right = 16
                    , top = 16
                    }
                ]
                [ if not <| String.isEmpty quest.moreInfo then
                    Element.el [ Element.alignRight, Element.alignTop, Font.color (Theme.highlight theme.kind 0.54), Element.htmlAttribute <| onClickNoBubble (OpenDialog quest.title quest.moreInfo), Element.pointer ] Icons.info

                  else
                    Element.none
                , Element.el [ Element.alignRight, Element.alignBottom, Font.size 12, Font.color (Theme.highlight theme.kind 0.54) ] <| Element.text quest.timeEstimate
                ]
            ]
        ]


fab : Theme -> Element msg
fab theme =
    Element.link
        Fab.bottomRight
        { url = Route.toString Route.AddQuest
        , label = Fab.regular theme Icons.add
        }


menu : Theme -> Element msg
menu theme =
    column
        [ Background.color theme.surface
        , Element.alignRight
        , Font.size 16
        , Font.color theme.onSurface
        , paddingXY 0 8
        , Border.rounded 4
        , Elevation.z8
        ]
        [ menuItem theme Route.Completions "My completions"
        , menuItem theme Route.Logout "Logout"
        ]


menuItem : Theme -> Route -> String -> Element msg
menuItem theme route txt =
    Element.link
        [ height (px 48)
        , paddingXY 16 0
        , width fill
        , Element.mouseDown
            [ Background.color <| Theme.highlight theme.kind 0.12 ]
        , Element.mouseOver
            [ Background.color <| Theme.highlight theme.kind 0.04 ]
        ]
        { url = Route.toString route
        , label = Element.el [ centerY ] <| text txt
        }
