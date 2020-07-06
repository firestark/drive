module Page.Quest.List exposing (Model, Msg, init, toSession, toTheme, update, view)

import Element exposing (Element, centerX, centerY, column, el, fill, height, link, maximum, paddingXY, px, rgb255, rgba255, row, scrollbarY, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input exposing (placeholder)
import Html exposing (Html)
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
    }


type Msg
    = UpdateSearch String
    | SwitchTheme


init : Session -> Theme -> ( Model, Cmd Msg )
init session theme =
    ( { theme = theme
      , session = session
      , searchText = ""
      , questList = Quest.mocks
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateSearch text ->
            ( { model | searchText = text }, Cmd.none )

        SwitchTheme ->
            ( { model | theme = Theme.switch model.theme.kind }, Cmd.none )


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


body : Model -> Html Msg
body model =
    Page.wrapper model.theme.background <|
        column
            [ width fill
            , height fill
            , Element.onRight <| fab model.theme
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


fab : Theme -> Element msg
fab theme =
    link
        Fab.bottomRight
        { url = Route.routeToString Route.QuestList
        , label = Fab.regular theme Icons.add
        }


topAppBar : Model -> Element Msg
topAppBar model =
    column [ width fill, Elevation.z2 ]
        [ topAppBarRow
            []
            [ input model ]
        , topAppBarRow []
            [ column [ spacing 2 ]
                [ text "Quests"
                , Element.el [ Font.size 13, Font.color (Element.rgba255 255 255 255 0.76) ] (text "0/1 done today")
                ]
            ]
        ]


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


topAppBarRow : List (Element.Attribute msg) -> List (Element msg) -> Element msg
topAppBarRow attributes elements =
    row
        (List.append
            attributes
            [ width fill
            , height (px 64)
            , Background.color (rgb255 103 58 183)
            , Font.color (rgb255 255 255 255)
            , Font.size 20
            , Element.paddingXY 16 0
            ]
        )
        elements


list : Theme -> ( String, List Quest ) -> Element msg
list theme ( category, quests ) =
    column [ width fill ]
        [ listDividerTitle theme category
        , Quest.list theme quests
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
