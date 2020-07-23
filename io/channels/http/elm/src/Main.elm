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
import Page.Quest.List
import Theme
import Url exposing (Url)
import Viewer exposing (Viewer)


type Model
    = Authenticated Data
    | Unauthenticated Page.Login.Model


type alias Data =
    { key : Browser.Navigation.Key
    , url : Url
    , questPage : Page.Quest.List.Model
    }


type Msg
    = AuthenticatedMsg SubMsg
    | UnauthenticatedMsg Page.Login.Msg
    | ViewerChanged (Maybe Viewer)


type SubMsg
    = LinkClicked Browser.UrlRequest
    | GotQuestListMsg Page.Quest.List.Msg
    | UrlChanged Url


init : Maybe Viewer -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init maybeViewer url navKey =
    let
        theme =
            Theme.light
    in
    case maybeViewer of
        Just _ ->
            ( Authenticated
                { key = navKey
                , url = url
                , questPage = Tuple.first <| Page.Quest.List.init theme
                }
            , Cmd.none
            )

        Nothing ->
            ( Unauthenticated (Page.Login.init navKey url theme), Cmd.none )


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
                                , questPage = Tuple.first <| Page.Quest.List.init loginModel.theme
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

        GotQuestListMsg subMsg ->
            ( Authenticated { model | questPage = Tuple.first (Page.Quest.List.update subMsg model.questPage) }, Cmd.none )

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
            , body = [ wrapper data.questPage.theme.background <| Element.map (AuthenticatedMsg << GotQuestListMsg) (Page.Quest.List.view data.questPage) ]
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
