module Main exposing (main)

import Api exposing (Cred)
import Browser
import Browser.Navigation as Nav
import Element exposing (Color, Element, fill, height, layout, width)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Json.Decode exposing (Value)
import Page.Login
import Page.Quest.Add
import Page.Quest.List
import Route exposing (Route)
import Theme exposing (Theme)
import Url exposing (Url)
import Viewer exposing (Viewer)



-- MODEL


type Model
    = Authenticated Session Page
    | Unauthenticated Page.Login.Model


type alias Session =
    { cred : Cred
    , key : Nav.Key
    , snackbar : Maybe String
    , theme : Theme
    }


type Page
    = AddQuest Page.Quest.Add.Model
    | Redirect
    | QuestList Page.Quest.List.Model


init : Maybe Viewer -> Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeViewer url navKey =
    let
        theme =
            Theme.dark
    in
    case maybeViewer of
        Just viewer ->
            changeRouteTo (Route.fromUrl url)
                (Authenticated (Session (Viewer.cred viewer) navKey Nothing theme) Redirect)

        Nothing ->
            changeRouteTo (Route.fromUrl url)
                (Unauthenticated <| Page.Login.init navKey theme)



-- UPDATE


type Msg
    = GotAddQuestMsg Page.Quest.Add.Msg
    | GotLoginMsg Page.Login.Msg
    | GotQuestListMsg Page.Quest.List.Msg
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | ViewerChanged (Maybe Viewer)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( model, msg ) of
        ( Authenticated session page, LinkClicked urlRequest ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( Authenticated session page, Nav.pushUrl session.key (Url.toString url) )

                Browser.External href ->
                    ( Authenticated session page, Nav.load href )

        ( Authenticated session (AddQuest page), GotAddQuestMsg subMsg ) ->
            case subMsg of
                Page.Quest.Add.AddedQuest (Ok _) ->
                    let
                        ( updatedModel, cmd ) =
                            Page.Quest.Add.update subMsg page
                    in
                    ( Authenticated { session | snackbar = Just "Quest added." } (AddQuest updatedModel), Cmd.batch [ Cmd.map GotAddQuestMsg cmd, Nav.pushUrl session.key "/" ] )

                _ ->
                    let
                        ( updatedModel, cmd ) =
                            Page.Quest.Add.update subMsg page
                    in
                    ( Authenticated session (AddQuest updatedModel), Cmd.map GotAddQuestMsg cmd )

        ( Authenticated session (QuestList page), GotQuestListMsg subMsg ) ->
            let
                ( updatedModel, cmd ) =
                    Page.Quest.List.update subMsg page
            in
            ( Authenticated session (QuestList updatedModel), Cmd.map GotQuestListMsg cmd )

        ( Unauthenticated loginModel, GotLoginMsg loginMsg ) ->
            let
                ( newLoginModel, cmd ) =
                    Page.Login.update loginMsg loginModel
            in
            ( Unauthenticated newLoginModel, Cmd.map GotLoginMsg cmd )

        ( Unauthenticated loginModel, ViewerChanged maybeViewer ) ->
            case maybeViewer of
                Just viewer ->
                    let
                        ( newModel, _ ) =
                            changeRouteTo
                                (Just Route.QuestList)
                            <|
                                Authenticated
                                    { cred = Viewer.cred viewer
                                    , key = loginModel.key
                                    , snackbar = Nothing
                                    , theme = loginModel.theme
                                    }
                                    Redirect
                    in
                    ( newModel, Nav.pushUrl loginModel.key (Route.toString Route.QuestList) )

                Nothing ->
                    ( model, Cmd.none )

        ( _, UrlChanged url ) ->
            changeRouteTo (Route.fromUrl url) model

        ( _, _ ) ->
            ( model, Cmd.none )


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    case model of
        Authenticated session _ ->
            case maybeRoute of
                Nothing ->
                    ( model, Cmd.none )

                Just Route.AddQuest ->
                    let
                        subModel =
                            Page.Quest.Add.init session.cred session.theme
                    in
                    ( Authenticated session (AddQuest subModel), Cmd.none )

                Just Route.Completions ->
                    ( model, Cmd.none )

                Just Route.Logout ->
                    let
                        ( newModel, _ ) =
                            changeRouteTo (Just Route.QuestList) (Unauthenticated <| Page.Login.init session.key session.theme)
                    in
                    ( newModel, Api.logout )

                Just Route.QuestList ->
                    let
                        ( subModel, cmd ) =
                            Page.Quest.List.init session.snackbar session.cred session.theme
                    in
                    ( Authenticated session (QuestList subModel), Cmd.map GotQuestListMsg cmd )

        Unauthenticated _ ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Api.viewerChanges ViewerChanged Viewer.decoder



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model of
        Unauthenticated loginModel ->
            { title = "Login"
            , body = [ wrapper loginModel.theme.background <| Element.map GotLoginMsg (Page.Login.view loginModel) ]
            }

        Authenticated session page ->
            case page of
                AddQuest data ->
                    { title = "Add quest"
                    , body = [ wrapper session.theme.background <| Element.map GotAddQuestMsg (Page.Quest.Add.view data) ]
                    }

                Redirect ->
                    { title = "Redirecting..."
                    , body = []
                    }

                QuestList data ->
                    { title = "Quest list"
                    , body = [ wrapper session.theme.background <| Element.map GotQuestListMsg (Page.Quest.List.view data) ]
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



-- APP


main : Program Value Model Msg
main =
    Api.application Viewer.decoder
        { init = init
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
