module Page.Quest.List exposing (Model, Msg, init, toSession, toTheme, update, view)

import Element exposing (Element, centerX, centerY, column, el, fill, height, maximum, paddingXY, px, rgb255, rgba255, row, scrollbarY, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input exposing (placeholder)
import Html exposing (Html)
import Material.Dialog exposing (dialog)
import Material.Elevation as Elevation
import Material.Fab as Fab
import Material.Icons as Icons
import Page
import Quest exposing (Quest)
import Route
import Session exposing (Session)
import Theme exposing (Theme)


type alias Model =
    { theme : Theme
    , session : Session
    , searchText : String
    , questList : List ( String, List Quest )
    , dialog : Dialog
    }


type Dialog
    = Open { title : String, moreInfo : String }
    | Closed


type Msg
    = CloseDialog
    | OpenDialog String String
    | SwitchTheme
    | UpdateSearch String


init : Session -> Theme -> ( Model, Cmd Msg )
init session theme =
    ( { theme = theme
      , session = session
      , searchText = ""
      , questList = Quest.mocks
      , dialog = Closed
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CloseDialog ->
            ( { model | dialog = Closed }, Cmd.none )

        OpenDialog title moreInfo ->
            ( { model | dialog = Open { title = title, moreInfo = moreInfo } }, Cmd.none )

        SwitchTheme ->
            ( { model | theme = Theme.switch model.theme.kind }, Cmd.none )

        UpdateSearch text ->
            ( { model | searchText = text }, Cmd.none )


toSession : Model -> Session
toSession model =
    model.session


toTheme : Model -> Theme
toTheme model =
    model.theme


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Quests"
    , content = body model
    }


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
            , Font.color (rgba255 0 0 0 0.38)
            , Border.width 0
            , Background.color (rgba255 0 0 0 0)
            ]
            { onChange = UpdateSearch
            , text = model.searchText
            , placeholder = Just <| placeholder [] (text "Search quests")
            , label = Input.labelHidden ""
            }
        , Element.el [ Font.color (rgba255 0 0 0 0.54) ] Icons.account_circle
        ]


body : Model -> Html Msg
body model =
    Page.wrapper model.theme.background <|
        column
            [ width fill
            , height fill
            , Element.onRight <| fab model.theme
            , case model.dialog of
                Open { title, moreInfo } ->
                    Element.inFront (dialog model.theme CloseDialog title moreInfo)

                Closed ->
                    Element.inFront <| Element.text ""
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
                List.map (list model.theme) model.questList
            ]



-- List


list : Theme -> ( String, List Quest ) -> Element Msg
list theme ( category, quests ) =
    column [ width fill ]
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
                , Element.el [ Element.alignRight, Element.alignBottom, Font.size 12, Font.color (Theme.highlight theme.kind 0.54) ] <| Element.text "5 min"
                ]
            ]
        ]


fab : Theme -> Element msg
fab theme =
    Element.link
        Fab.bottomRight
        { url = Route.routeToString Route.QuestList
        , label = Fab.regular theme Icons.add
        }
