module Page.Login exposing (Model, Msg, init, update, view)

import Api
import Browser.Navigation
import Element exposing (Element, column, fill, height, paddingXY, px, rgba255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Http
import Json.Encode as Encode
import Material.Elevation as Elevation
import Material.Icons as Icons
import Process
import Task
import Theme exposing (Theme)
import Viewer exposing (Viewer)


type alias Model =
    { form : Form
    , key : Browser.Navigation.Key
    , problems : List Problem
    , showPassword : Bool
    , showSnackbar : Bool
    , theme : Theme
    }


type Problem
    = InvalidEntry ValidatedField String
    | ServerError String


type alias Form =
    { name : String
    , password : String
    }


init : Browser.Navigation.Key -> Theme -> Model
init key theme =
    { form = Form "" ""
    , key = key
    , problems = []
    , showPassword = False
    , showSnackbar = False
    , theme = theme
    }


type Msg
    = CompletedLogin (Result Http.Error Viewer)
    | EnteredName String
    | EnteredPassword String
    | HideSnackbar
    | ShowPasswordToggled
    | ShowSnackbar
    | SubmittedForm


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CompletedLogin (Err error) ->
            let
                serverErrors =
                    Api.decodeErrors error
                        |> List.map ServerError

                newModel =
                    { model | problems = List.append model.problems serverErrors }
            in
            update ShowSnackbar newModel

        CompletedLogin (Ok viewer) ->
            ( model
            , Viewer.store viewer
            )

        EnteredName name ->
            updateForm (\form -> { form | name = name }) model

        EnteredPassword password ->
            updateForm (\form -> { form | password = password }) model

        HideSnackbar ->
            ( { model | showSnackbar = False }, Cmd.none )

        ShowPasswordToggled ->
            ( { model | showPassword = not model.showPassword }, Cmd.none )

        ShowSnackbar ->
            ( { model | showSnackbar = True }, delay 5000 HideSnackbar )

        SubmittedForm ->
            case validate model.form of
                Ok validForm ->
                    ( { model | problems = [] }
                    , login validForm
                    )

                Err problems ->
                    ( { model | problems = problems }
                    , Cmd.none
                    )


{-| Helper function for `update`. Updates the form and returns Cmd.none.
Useful for recording form fields!
-}
updateForm : (Form -> Form) -> Model -> ( Model, Cmd Msg )
updateForm transform model =
    ( { model | form = transform model.form }, Cmd.none )


delay : Float -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.perform (\_ -> msg)



-- View


view : Model -> Element Msg
view model =
    column
        [ paddingXY 24 80
        , width fill
        , spacing 16
        , Element.alignBottom
        , Element.inFront <|
            if model.showSnackbar then
                snackbar

            else
                Element.none
        ]
        [ inputName model
        , inputPassword model
        , loginButton model.theme
        ]


inputName : Model -> Element Msg
inputName model =
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
            [ Element.el [ Font.color <| Theme.highlight model.theme.kind 0.54 ] Icons.account_circle
            , Input.text
                [ Font.size 16
                , Font.light
                , Font.color <| Theme.highlight model.theme.kind 0.87
                , Border.width 0
                , Background.color (rgba255 0 0 0 0)
                ]
                { onChange = EnteredName
                , text = model.form.name
                , placeholder = Just <| Input.placeholder [ Font.color <| Theme.highlight model.theme.kind 0.38 ] (text "Name*")
                , label = Input.labelHidden ""
                }
            ]
        , viewFieldErrors model.theme Name model.problems
        ]


inputPassword : Model -> Element Msg
inputPassword model =
    column []
        [ row
            [ height (px 56)
            , width fill
            , Border.rounded 4
            , Border.width 0
            , Background.color (rgba255 0 0 0 0.07)
            , Element.paddingXY 16 0
            , spacing 16
            ]
            [ Element.el [ Font.color <| Theme.highlight model.theme.kind 0.54 ] Icons.lock
            , Input.newPassword
                [ Font.size 16
                , Font.light
                , Font.color <| Theme.highlight model.theme.kind 0.87
                , Border.width 0
                , Background.color (rgba255 0 0 0 0)
                ]
                { onChange = EnteredPassword
                , text = model.form.password
                , placeholder = Just <| Input.placeholder [ Font.color <| Theme.highlight model.theme.kind 0.38 ] (text "Password*")
                , label = Input.labelHidden ""
                , show = model.showPassword
                }
            , Element.el [ Font.color <| Theme.highlight model.theme.kind 0.54, onClick ShowPasswordToggled ] Icons.visibility
            ]
        , viewFieldErrors model.theme Password model.problems
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


loginButton : Theme -> Element Msg
loginButton theme =
    Input.button
        [ Background.color theme.primary
        , Font.color theme.onPrimary
        , Font.size 14
        , Font.bold
        , Element.alignRight
        , paddingXY 16 0
        , height (px 36)
        , Border.rounded 4
        ]
        { onPress = Just SubmittedForm
        , label = text "LOGIN"
        }


snackbar : Element msg
snackbar =
    column
        [ Element.alignBottom
        , width fill
        , paddingXY 8 8
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
            [ text "Login failed, wrong credentials." ]
        ]



-- FORM


{-| Marks that we've trimmed the form's fields, so we don't accidentally send
it to the server without having trimmed it!
-}
type TrimmedForm
    = Trimmed Form


{-| When adding a variant here, add it to `fieldsToValidate` too!
-}
type ValidatedField
    = Name
    | Password


fieldsToValidate : List ValidatedField
fieldsToValidate =
    [ Name
    , Password
    ]


{-| Trim the form and validate its fields. If there are problems, report them!
-}
validate : Form -> Result (List Problem) TrimmedForm
validate form =
    let
        trimmedForm =
            trimFields form
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
            Name ->
                if String.isEmpty form.name then
                    [ "Name can't be blank." ]

                else
                    []

            Password ->
                if String.isEmpty form.password then
                    [ "Password can't be blank." ]

                else
                    []


{-| Don't trim while the user is typing! That would be super annoying.
Instead, trim only on submit.
-}
trimFields : Form -> TrimmedForm
trimFields form =
    Trimmed
        { name = String.trim form.name
        , password = String.trim form.password
        }


login : TrimmedForm -> Cmd Msg
login (Trimmed form) =
    let
        user =
            Encode.object
                [ ( "name", Encode.string form.name )
                , ( "password", Encode.string form.password )
                ]
    in
    Api.login (user |> Http.jsonBody) CompletedLogin Viewer.decoder
