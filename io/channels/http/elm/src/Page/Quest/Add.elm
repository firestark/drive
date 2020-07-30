module Page.Quest.Add exposing (Model, Msg(..), init, update, view)

import Api exposing (Cred)
import Api.Endpoint as Endpoint
import Element exposing (Element, centerX, column, fill, height, maximum, paddingXY, px, rgba255, row, scrollbarY, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Http
import Json.Encode as Encode
import Material.Elevation as Elevation
import Material.Fab as Fab
import Material.Icons as Icons
import Quest exposing (Quest)
import Route
import Theme exposing (Theme)



-- MODEL


type alias Model =
    { cred : Cred
    , form : Form
    , problems : List Problem
    , theme : Theme
    }


type alias Form =
    { title : String
    , description : String
    , category : String
    , timeEstimate : String
    , moreInfo : String
    }


type Problem
    = InvalidEntry ValidatedField String
    | ServerError String


init : Cred -> Theme -> Model
init cred theme =
    { cred = cred
    , form = emptyForm
    , problems = []
    , theme = theme
    }


emptyForm : Form
emptyForm =
    { title = ""
    , description = ""
    , category = ""
    , timeEstimate = ""
    , moreInfo = ""
    }



-- UPDATE


type Msg
    = AddedQuest (Result Http.Error Quest)
    | EnteredTitle String
    | EnteredDescription String
    | EnteredCategory String
    | EnteredTimeEstimate String
    | EnteredMoreInfo String
    | SubmittedForm


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddedQuest (Err error) ->
            -- Here we should go ahead and figure out the status that is returned to specifically set errors
            -- About the input (for example in this case the title already exists error)
            case error of
                Http.BadStatus 409 ->
                    ( { model | problems = List.append model.problems [ InvalidEntry Title "Title already exists." ] }, Cmd.none )

                _ ->
                    let
                        serverErrors =
                            Api.decodeErrors error
                                |> List.map ServerError

                        newModel =
                            { model | problems = List.append model.problems serverErrors }
                    in
                    ( newModel, Cmd.none )

        AddedQuest (Ok _) ->
            ( { model | form = emptyForm }, Cmd.none )

        EnteredTitle title ->
            updateForm (\form -> { form | title = title }) model

        EnteredDescription description ->
            if String.length description > maxDescriptionLength then
                ( model, Cmd.none )

            else
                updateForm (\form -> { form | description = description }) model

        EnteredCategory category ->
            if String.length category > maxCategoryLength then
                ( model, Cmd.none )

            else
                updateForm (\form -> { form | category = category }) model

        EnteredTimeEstimate timeEstimate ->
            updateForm (\form -> { form | timeEstimate = timeEstimate }) model

        EnteredMoreInfo moreInfo ->
            if String.length moreInfo > maxMoreInfoLength then
                ( model, Cmd.none )

            else
                updateForm (\form -> { form | moreInfo = moreInfo }) model

        SubmittedForm ->
            case validate model of
                Ok validForm ->
                    ( { model | problems = [] }
                    , submit model.cred validForm
                    )

                Err problems ->
                    ( { model | problems = problems }
                    , Cmd.none
                    )



-- FORM


{-| Marks that we've trimmed the form's fields, so we don't accidentally send
it to the server without having trimmed it!
-}
type TrimmedForm
    = Trimmed Form


maxDescriptionLength : Int
maxDescriptionLength =
    80


maxCategoryLength : Int
maxCategoryLength =
    80


maxMoreInfoLength : Int
maxMoreInfoLength =
    255


{-| Helper function for `update`. Updates the form and returns Cmd.none.
Useful for recording form fields!
-}
updateForm : (Form -> Form) -> Model -> ( Model, Cmd Msg )
updateForm transform model =
    ( { model | form = transform model.form }, Cmd.none )


type ValidatedField
    = Title
    | Description
    | Category
    | TimeEstimate
    | MoreInfo


fieldsToValidate : List ValidatedField
fieldsToValidate =
    [ Title
    , Description
    , Category
    , TimeEstimate
    ]


{-| Trim the form and validate its fields. If there are problems, report them!
-}
validate : Model -> Result (List Problem) TrimmedForm
validate model =
    let
        trimmedForm =
            trimFields model.form
    in
    case List.concatMap (validateField trimmedForm) fieldsToValidate of
        [] ->
            Ok trimmedForm

        problems ->
            Err problems


validateField : TrimmedForm -> ValidatedField -> List Problem
validateField (Trimmed form) field =
    List.map (InvalidEntry field) <|
        case field of
            Title ->
                if String.isEmpty form.title then
                    [ "Title can't be blank." ]

                else
                    []

            Description ->
                if String.isEmpty form.description then
                    [ "Description can't be blank." ]

                else
                    []

            Category ->
                if String.isEmpty form.category then
                    [ "Category can't be blank." ]

                else
                    []

            TimeEstimate ->
                if String.isEmpty form.timeEstimate then
                    [ "Time estimate can't be blank." ]

                else
                    []

            MoreInfo ->
                []


{-| Don't trim while the user is typing! That would be super annoying.
Instead, trim only on submit.
-}
trimFields : Form -> TrimmedForm
trimFields { title, description, category, timeEstimate, moreInfo } =
    Trimmed
        { title = String.trim title
        , description = String.trim description
        , category = String.trim category
        , timeEstimate = String.trim timeEstimate
        , moreInfo = String.trim moreInfo
        }


submit : Cred -> TrimmedForm -> Cmd Msg
submit cred (Trimmed form) =
    let
        quest =
            Encode.object
                [ ( "title", Encode.string form.title )
                , ( "description", Encode.string form.description )
                , ( "category", Encode.string form.category )
                , ( "time estimate", Encode.string form.timeEstimate )
                , ( "moreInfo", Encode.string form.moreInfo )
                ]
    in
    Api.post Endpoint.addQuest (Just cred) AddedQuest (quest |> Http.jsonBody) Quest.itemDecoder



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
            , inputTimeEstimate model
            , inputMoreInfo model
            ]
        ]


topAppBar : Model -> Element msg
topAppBar model =
    column [ width fill, Elevation.z2 ]
        [ topAppBarRow model.theme
            []
            [ row [ spacing 32 ]
                [ Element.link
                    []
                    { url = Route.toString Route.QuestList
                    , label = Icons.arrow_back
                    }
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


fab : Theme -> Element Msg
fab theme =
    Element.el (List.append [ onClick SubmittedForm ] Fab.bottomRight) (Fab.regular theme Icons.check)


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
                , Font.color <| Theme.highlight model.theme.kind 0.87
                , Border.width 0
                , Background.color (rgba255 0 0 0 0)
                ]
                { onChange = EnteredTitle
                , text = model.form.title
                , placeholder = Just <| Input.placeholder [ Font.color <| Theme.highlight model.theme.kind 0.38 ] (text "Title*")
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
                , Font.color <| Theme.highlight model.theme.kind 0.87
                , Border.width 0
                , Background.color (rgba255 0 0 0 0)
                ]
                { onChange = EnteredDescription
                , text = model.form.description
                , placeholder = Just <| Input.placeholder [ Font.color <| Theme.highlight model.theme.kind 0.38 ] (text "Description*")
                , label = Input.labelHidden ""
                }
            , maxLength model.theme maxDescriptionLength model.form.description
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
                , Font.color <| Theme.highlight model.theme.kind 0.87
                , Border.width 0
                , Background.color (rgba255 0 0 0 0)
                ]
                { onChange = EnteredCategory
                , text = model.form.category
                , placeholder = Just <| Input.placeholder [ Font.color <| Theme.highlight model.theme.kind 0.38 ] (text "Category*")
                , label = Input.labelHidden ""
                }
            , maxLength model.theme maxCategoryLength model.form.category
            ]
        , viewFieldErrors model.theme Category model.problems
        ]


inputTimeEstimate : Model -> Element Msg
inputTimeEstimate model =
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
                , Font.color <| Theme.highlight model.theme.kind 0.87
                , Border.width 0
                , Background.color (rgba255 0 0 0 0)
                ]
                { onChange = EnteredTimeEstimate
                , text = model.form.timeEstimate
                , placeholder = Just <| Input.placeholder [ Font.color <| Theme.highlight model.theme.kind 0.38 ] (text "Time estimate*")
                , label = Input.labelHidden ""
                }
            ]
        , viewFieldErrors model.theme TimeEstimate model.problems
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
                , Font.color <| Theme.highlight model.theme.kind 0.87
                , Border.width 0
                , Background.color (rgba255 0 0 0 0)
                , height fill
                , width fill
                ]
                { onChange = EnteredMoreInfo
                , text = model.form.moreInfo
                , placeholder = Just <| Input.placeholder [ Font.color <| Theme.highlight model.theme.kind 0.38 ] (text "More info")
                , label = Input.labelHidden ""
                , spellcheck = True
                }
            , Element.el
                [ height fill
                , paddingXY 0 16
                ]
              <|
                maxLength model.theme maxMoreInfoLength model.form.moreInfo
            ]
        , viewFieldErrors model.theme MoreInfo model.problems
        ]


maxLength : Theme -> Int -> String -> Element msg
maxLength theme max field =
    row
        [ Font.size 16 ]
        [ Element.el [ Font.color <| Theme.highlight theme.kind 0.87 ] <| text (String.fromInt <| String.length field)
        , Element.el [ Font.color <| Theme.highlight theme.kind 0.6 ] <| text <| "/" ++ String.fromInt max
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
