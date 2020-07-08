module Page.Login exposing (Model, Msg, init, subscriptions, toSession, update, view)

{-| The login page.
-}

import Api
import Element exposing (Element, column, fill, height, paddingXY, px, rgb255, rgba255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Http
import Json.Decode exposing (string)
import Json.Encode as Encode
import Material.Icons as Icons
import Page
import Route
import Session exposing (Session)
import Theme exposing (Theme)
import Viewer exposing (Viewer)



-- MODEL


type alias Model =
    { session : Session
    , problems : List Problem
    , form : Form
    , theme : Theme
    }


{-| Recording validation problems on a per-field basis facilitates displaying
them inline next to the field where the error occurred.

I implemented it this way out of habit, then realized the spec called for
displaying all the errors at the top. I thought about simplifying it, but then
figured it'd be useful to show how I would normally model this data - assuming
the intended UX was to render errors per field.

(The other part of this is having a view function like this:

viewFieldErrors : ValidatedField -> List Problem -> Html msg

...and it filters the list of problems to render only InvalidEntry ones for the
given ValidatedField. That way you can call this:

viewFieldErrors Email problems

...next to the `email` field, and call `viewFieldErrors Password problems`
next to the `password` field, and so on.

The `LoginError` should be displayed elsewhere, since it doesn't correspond to
a particular field.

-}
type Problem
    = InvalidEntry ValidatedField String
    | ServerError String


type alias Form =
    { email : String
    , password : String
    }


init : Session -> Theme -> ( Model, Cmd msg )
init session theme =
    ( { session = session
      , problems = []
      , form =
            { email = ""
            , password = ""
            }
      , theme = theme
      }
    , Cmd.none
    )



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Login"
    , content = body model
    }


body : Model -> Html Msg
body model =
    Page.wrapper model.theme.background <|
        column [ paddingXY 24 0, width fill, spacing 24 ]
            [ inputUsername model
            , inputPassword model
            ]


inputUsername : Model -> Element Msg
inputUsername model =
    row
        [ height (px 48)
        , width fill
        , Border.rounded 4
        , Border.width 0
        , Background.color (rgba255 0 0 0 0.07)
        , Element.paddingXY 16 0
        , spacing 16
        ]
        [ Element.el [ Font.color (rgba255 0 0 0 0.54) ] Icons.account_circle
        , Input.text
            [ Font.size 16
            , Font.light
            , Font.color (rgba255 0 0 0 0.38)
            , Border.width 0
            , Background.color (rgba255 0 0 0 0)
            ]
            { onChange = EnteredEmail
            , text = model.form.email
            , placeholder = Just <| Input.placeholder [] (text "Username*")
            , label = Input.labelHidden ""
            }
        ]


inputPassword : Model -> Element Msg
inputPassword model =
    row
        [ height (px 48)
        , width fill
        , Border.rounded 4
        , Border.width 0
        , Background.color (rgba255 0 0 0 0.07)
        , Element.paddingXY 16 0
        , spacing 16
        ]
        [ Element.el [ Font.color (rgba255 0 0 0 0.54) ] Icons.lock
        , Input.text
            [ Font.size 16
            , Font.light
            , Font.color (rgba255 0 0 0 0.38)
            , Border.width 0
            , Background.color (rgba255 0 0 0 0)
            ]
            { onChange = EnteredEmail
            , text = model.form.email
            , placeholder = Just <| Input.placeholder [] (text "Password*")
            , label = Input.labelHidden ""
            }
        ]



-- UPDATE


type Msg
    = SubmittedForm
    | EnteredEmail String
    | EnteredPassword String
    | CompletedLogin (Result Http.Error Viewer)
    | GotSession Session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmittedForm ->
            case validate model.form of
                Ok validForm ->
                    ( { model | problems = [] }
                    , Http.send CompletedLogin (login validForm)
                    )

                Err problems ->
                    ( { model | problems = problems }
                    , Cmd.none
                    )

        EnteredEmail email ->
            updateForm (\form -> { form | email = email }) model

        EnteredPassword password ->
            updateForm (\form -> { form | password = password }) model

        CompletedLogin (Err error) ->
            let
                serverErrors =
                    Api.decodeErrors error
                        |> List.map ServerError
            in
            ( { model | problems = List.append model.problems serverErrors }
            , Cmd.none
            )

        CompletedLogin (Ok viewer) ->
            ( model
            , Viewer.store viewer
            )

        GotSession session ->
            ( { model | session = session }
            , Route.replaceUrl (Session.navKey session) Route.QuestList
            )


{-| Helper function for `update`. Updates the form and returns Cmd.none.
Useful for recording form fields!
-}
updateForm : (Form -> Form) -> Model -> ( Model, Cmd Msg )
updateForm transform model =
    ( { model | form = transform model.form }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- FORM


{-| Marks that we've trimmed the form's fields, so we don't accidentally send
it to the server without having trimmed it!
-}
type TrimmedForm
    = Trimmed Form


{-| When adding a variant here, add it to `fieldsToValidate` too!
-}
type ValidatedField
    = Email
    | Password


fieldsToValidate : List ValidatedField
fieldsToValidate =
    [ Email
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
            Email ->
                if String.isEmpty form.email then
                    [ "email can't be blank." ]

                else
                    []

            Password ->
                if String.isEmpty form.password then
                    [ "password can't be blank." ]

                else
                    []


{-| Don't trim while the user is typing! That would be super annoying.
Instead, trim only on submit.
-}
trimFields : Form -> TrimmedForm
trimFields form =
    Trimmed
        { email = String.trim form.email
        , password = String.trim form.password
        }



-- HTTP


login : TrimmedForm -> Http.Request Viewer
login (Trimmed form) =
    let
        user =
            Encode.object
                [ ( "email", Encode.string form.email )
                , ( "password", Encode.string form.password )
                ]

        body1 =
            Encode.object [ ( "user", user ) ]
                |> Http.jsonBody
    in
    Api.login body1 Viewer.decoder



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session
