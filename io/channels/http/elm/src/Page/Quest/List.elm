module Page.Quest.List exposing (Model, Msg, init, update, view)

import Api exposing (Cred)
import Api.Endpoint as Endpoint
import Element exposing (Element, centerX, centerY, column, el, fill, height, maximum, paddingXY, px, rgb255, rgba255, row, scrollbarY, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input exposing (placeholder)
import Http
import Material.Dialog exposing (dialog)
import Material.Elevation as Elevation
import Material.Fab as Fab
import Material.Icons as Icons
import Quest exposing (Quest)
import RemoteData exposing (WebData)
import Route
import Theme exposing (Theme)


type alias Model =
    { theme : Theme
    , searchText : String
    , questList : WebData (List Quest)
    , dialog : Dialog
    }


type Dialog
    = Closed
    | Open { title : String, moreInfo : String }


type Msg
    = CloseDialog
    | GotQuests (WebData (List Quest))
    | OpenDialog String String
    | UpdateSearch String


init : Cred -> Theme -> ( Model, Cmd Msg )
init cred theme =
    ( { theme = theme
      , searchText = ""
      , questList = RemoteData.NotAsked
      , dialog = Closed
      }
    , request cred
    )


request : Cred -> Cmd Msg
request cred =
    Api.get Endpoint.quests (Just cred) GotQuests Quest.decoder


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CloseDialog ->
            ( { model | dialog = Closed }, Cmd.none )

        GotQuests response ->
            ( { model | questList = response }, Cmd.none )

        OpenDialog title moreInfo ->
            ( { model | dialog = Open { title = title, moreInfo = moreInfo } }, Cmd.none )

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


data : Model -> List (Element Msg)
data model =
    case model.questList of
        RemoteData.NotAsked ->
            [ text "You didnt ask me so i will do nothing" ]

        RemoteData.Loading ->
            [ text "Loading..." ]

        RemoteData.Success quests ->
            if String.isEmpty model.searchText then
                List.map (list model.theme) (sort quests)

            else
                List.map (list model.theme) (sort <| List.filter (filter model.searchText) quests)

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
                    (text "0/1 done today")
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
        , Element.el [ Font.color (rgba255 0 0 0 0.54) ] Icons.account_circle
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
        List.map (threeLineElement theme) quests


threeLineElement : Theme -> Quest -> Element Msg
threeLineElement theme quest =
    threeElement theme quest


threeElement : Theme -> Quest -> Element Msg
threeElement theme quest =
    row
        [ width fill, spacing 32 ]
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
                [ Element.el [ Element.alignRight, Element.alignTop, Font.color (Theme.highlight theme.kind 0.54), onClick (OpenDialog quest.title quest.moreInfo), Element.pointer ] Icons.info
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
