module Page.Quest.Add exposing (Model, Msg, init, update, view)

import Element exposing (Element, centerX, column, fill, height, maximum, paddingXY, px, rgba255, row, scrollbarY, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Material.Elevation as Elevation
import Material.Fab as Fab
import Material.Icons as Icons
import Route
import Theme exposing (Theme)



-- MODEL


type alias Model =
    { form : Form
    , problems : List Problem
    , theme : Theme
    }


type alias Form =
    { title : String
    , description : String
    , category : String
    , moreInfo : String
    }


type Problem
    = InvalidEntry ValidatedField String
    | ServerError String


init : Theme -> Model
init theme =
    { form =
        { title = ""
        , description = ""
        , category = ""
        , moreInfo = ""
        }
    , problems = []
    , theme = theme
    }



-- UPDATE


type Msg
    = EnteredTitle String
    | EnteredDescription String
    | EnteredCategory String
    | EnteredMoreInfo String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EnteredTitle title ->
            updateForm (\form -> { form | title = title }) model

        EnteredDescription description ->
            updateForm (\form -> { form | description = description }) model

        EnteredCategory category ->
            updateForm (\form -> { form | category = category }) model

        EnteredMoreInfo moreInfo ->
            updateForm (\form -> { form | moreInfo = moreInfo }) model


{-| Helper function for `update`. Updates the form and returns Cmd.none.
Useful for recording form fields!
-}
updateForm : (Form -> Form) -> Model -> ( Model, Cmd Msg )
updateForm transform model =
    ( { model | form = transform model.form }, Cmd.none )



-- VIEW


view : Model -> Element Msg
view model =
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
                { top = 16
                , right = 16
                , bottom = 72
                , left = 16
                }
            , spacing 16
            ]
            [ inputTitle model
            , inputDescription model
            , inputCategory model
            , inputMoreInfo model
            ]
        ]


topAppBar : Model -> Element msg
topAppBar model =
    column [ width fill, Elevation.z2 ]
        [ topAppBarRow model.theme
            []
            [ row [ spacing 32 ]
                [ Element.el [] <| Icons.arrow_back
                , text "New quest"
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


fab : Theme -> Element msg
fab theme =
    Element.link
        Fab.bottomRight
        { url = Route.toString Route.AddQuest
        , label = Fab.regular theme Icons.add
        }


inputTitle : Model -> Element Msg
inputTitle model =
    column [ width fill ]
        [ row
            [ height (px 56)
            , width fill
            , Border.rounded 4
            , Border.width 0
            , Background.color (rgba255 0 0 0 0.07)
            , Element.paddingXY 16 0
            , spacing 16
            ]
            [ Input.text
                [ Font.size 16
                , Font.light
                , Font.color <| Theme.highlight model.theme.kind 0.38
                , Border.width 0
                , Background.color (rgba255 0 0 0 0)
                ]
                { onChange = EnteredTitle
                , text = model.form.title
                , placeholder = Just <| Input.placeholder [] (text "Title*")
                , label = Input.labelHidden ""
                }
            ]
        , viewFieldErrors model.theme Title model.problems
        ]


inputDescription : Model -> Element Msg
inputDescription model =
    column [ width fill ]
        [ row
            [ height (px 56)
            , width fill
            , Border.rounded 4
            , Border.width 0
            , Background.color (rgba255 0 0 0 0.07)
            , Element.paddingXY 16 0
            , spacing 16
            ]
            [ Input.text
                [ Font.size 16
                , Font.light
                , Font.color <| Theme.highlight model.theme.kind 0.38
                , Border.width 0
                , Background.color (rgba255 0 0 0 0)
                ]
                { onChange = EnteredDescription
                , text = model.form.description
                , placeholder = Just <| Input.placeholder [] (text "Description*")
                , label = Input.labelHidden ""
                }
            ]
        , viewFieldErrors model.theme Description model.problems
        ]


inputCategory : Model -> Element Msg
inputCategory model =
    column [ width fill ]
        [ row
            [ height (px 56)
            , width fill
            , Border.rounded 4
            , Border.width 0
            , Background.color (rgba255 0 0 0 0.07)
            , Element.paddingXY 16 0
            , spacing 16
            ]
            [ Input.text
                [ Font.size 16
                , Font.light
                , Font.color <| Theme.highlight model.theme.kind 0.38
                , Border.width 0
                , Background.color (rgba255 0 0 0 0)
                ]
                { onChange = EnteredCategory
                , text = model.form.category
                , placeholder = Just <| Input.placeholder [] (text "Category*")
                , label = Input.labelHidden ""
                }
            ]
        , viewFieldErrors model.theme Category model.problems
        ]


inputMoreInfo : Model -> Element Msg
inputMoreInfo model =
    column [ width fill ]
        [ row
            [ height (px 112)
            , width fill
            , Border.rounded 4
            , Border.width 0
            , Background.color (rgba255 0 0 0 0.07)
            , Element.paddingXY 16 8
            , spacing 16
            ]
            [ Input.multiline
                [ Font.size 16
                , Font.light
                , Font.color <| Theme.highlight model.theme.kind 0.38
                , Border.width 0
                , Background.color (rgba255 0 0 0 0)
                , height fill
                ]
                { onChange = EnteredMoreInfo
                , text = model.form.moreInfo
                , placeholder = Just <| Input.placeholder [] (text "More info*")
                , label = Input.labelHidden ""
                , spellcheck = True
                }
            ]
        , viewFieldErrors model.theme MoreInfo model.problems
        ]


inputError : Theme -> String -> Element msg
inputError theme problem =
    Element.el [ Font.color theme.error, Font.size 13, paddingXY 16 8, Font.semiBold ] <| text problem


viewFieldErrors : Theme -> ValidatedField -> List Problem -> Element msg
viewFieldErrors theme field problems =
    let
        error =
            List.head <| List.filter (isFieldError field) problems
    in
    case error of
        Just (InvalidEntry _ problem) ->
            inputError theme problem

        _ ->
            inputError theme ""


isFieldError : ValidatedField -> Problem -> Bool
isFieldError field problem =
    case problem of
        InvalidEntry invalidField _ ->
            invalidField == field

        ServerError _ ->
            False


type ValidatedField
    = Title
    | Description
    | Category
    | MoreInfo
