module Main exposing (main)

import Api
import Browser
import Browser.Navigation
import Element exposing (Color, Element, fill, height, layout, width)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Json.Decode exposing (Value)
import Page.Login
import Theme
import Url exposing (Url)
import Viewer exposing (Viewer)


type Model
    = Authenticated Data
    | Unauthenticated Page.Login.Model


type alias Data =
    { key : Browser.Navigation.Key
    , url : Url
    }


type Msg
    = AuthenticatedMsg SubMsg
    | UnauthenticatedMsg Page.Login.Msg
    | ViewerChanged (Maybe Viewer)


type SubMsg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url


init : Maybe Viewer -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init maybeViewer url navKey =
    case maybeViewer of
        Just _ ->
            ( Authenticated
                { key = navKey
                , url = url
                }
            , Cmd.none
            )

        Nothing ->
            ( Unauthenticated (Page.Login.init navKey url Theme.light), Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AuthenticatedMsg subMsg ->
            case model of
                Authenticated data ->
                    updateAuthenticated subMsg data

                Unauthenticated _ ->
                    ( model, Cmd.none )

        UnauthenticatedMsg loginMsg ->
            case model of
                Authenticated _ ->
                    ( model, Cmd.none )

                Unauthenticated loginModel ->
                    updateUnauthenticated loginMsg loginModel

        ViewerChanged maybeViewer ->
            case model of
                Authenticated _ ->
                    ( model, Cmd.none )

                Unauthenticated loginModel ->
                    case maybeViewer of
                        Just _ ->
                            ( Authenticated
                                { key = loginModel.key
                                , url = loginModel.url
                                }
                            , Cmd.none
                            )

                        Nothing ->
                            ( model, Cmd.none )


updateAuthenticated : SubMsg -> Data -> ( Model, Cmd Msg )
updateAuthenticated msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( Authenticated model, Browser.Navigation.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( Authenticated model, Browser.Navigation.load href )

        UrlChanged url ->
            ( Authenticated { model | url = url }
            , Cmd.none
            )


updateUnauthenticated : Page.Login.Msg -> Page.Login.Model -> ( Model, Cmd Msg )
updateUnauthenticated msg model =
    let
        ( newLoginPageModel, cmd ) =
            Page.Login.update msg model
    in
    ( Unauthenticated newLoginPageModel, Cmd.map UnauthenticatedMsg cmd )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Api.viewerChanges ViewerChanged Viewer.decoder


main : Program Value Model Msg
main =
    Api.application Viewer.decoder
        { init = init
        , onUrlChange = AuthenticatedMsg << UrlChanged
        , onUrlRequest = AuthenticatedMsg << LinkClicked
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


view : Model -> Browser.Document Msg
view model =
    case model of
        Unauthenticated loginModel ->
            { title = "Login"
            , body = [ wrapper loginModel.theme.background <| Element.map UnauthenticatedMsg (Page.Login.view loginModel) ]
            }

        Authenticated data ->
            { title = "My title"
            , body = [ Element.layout [] <| viewBody data ]
            }


wrapper : Color -> Element msg -> Html msg
wrapper background element =
    layout
        [ height fill
        , width fill
        , Background.color background
        , Font.family
            [ Font.typeface "Nunito"
            , Font.typeface "Roboto"
            , Font.typeface "Open Sans"
            , Font.sansSerif
            ]
        ]
        element


viewBody : Data -> Element msg
viewBody data =
    Element.column []
        [ Element.text <| "The current url is " ++ Url.toString data.url
        , links
        ]


links : Element msg
links =
    Element.row []
        [ link "/home" "home"
        , link "/profile" "profile"
        ]


link : String -> String -> Element msg
link url label =
    Element.link []
        { url = url
        , label = Element.text label
        }
