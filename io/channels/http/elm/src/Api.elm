port module Api exposing (Cred, addServerError, application, decodeErrors, delete, get, login, logout, post, put, register, settings, storeCredWith, username, viewerChanges)

{-| This module is responsible for communicating to the API.

It exposes an opaque Endpoint type which is guaranteed to point to the correct URL.

-}

import Api.Endpoint as Endpoint exposing (Endpoint)
import Avatar exposing (Avatar)
import Browser
import Browser.Navigation as Nav
import Http exposing (Body)
import Json.Decode as Decode exposing (Decoder, Value, decodeString, field, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import RemoteData exposing (WebData)
import Url exposing (Url)
import Username exposing (Username)



-- CRED


{-| The authentication credentials for the Viewer (that is, the currently logged-in user.)

This includes:

  - The cred's Username
  - The cred's authentication token

By design, there is no way to access the token directly as a String.
It can be encoded for persistence, and it can be added to a header
to a HttpBuilder for a request, but that's it.

This token should never be rendered to the end user, and with this API, it
can't be!

-}
type Cred
    = Cred Username String


username : Cred -> Username
username (Cred val _) =
    val


credHeader : Cred -> Http.Header
credHeader (Cred _ token) =
    Http.header "authorization" token


{-| It's important that this is never exposed!

We expose `login` and `application` instead, so we can be certain that if anyone
ever has access to a `Cred` value, it came from either the login API endpoint
or was passed in via flags.

-}
credDecoder : Decoder Cred
credDecoder =
    Decode.succeed Cred
        |> required "username" Username.decoder
        |> required "token" Decode.string



-- PERSISTENCE


port onStoreChange : (Value -> msg) -> Sub msg


viewerChanges : (Maybe viewer -> msg) -> Decoder (Cred -> viewer) -> Sub msg
viewerChanges toMsg decoder =
    onStoreChange (\value -> toMsg (decodeFromChange decoder value))


decodeFromChange : Decoder (Cred -> viewer) -> Value -> Maybe viewer
decodeFromChange viewerDecoder val =
    -- It's stored in localStorage as a JSON String;
    -- first decode the Value as a String, then
    -- decode that String as JSON.
    Decode.decodeValue (storageDecoder viewerDecoder) val
        |> Result.toMaybe


storeCredWith : Cred -> Avatar -> Cmd msg
storeCredWith (Cred name token) avatar =
    let
        json =
            Encode.object
                [ ( "user"
                  , Encode.object
                        [ ( "username", Username.encode name )
                        , ( "token", Encode.string token )
                        , ( "image", Avatar.encode avatar )
                        ]
                  )
                ]
    in
    storeCache (Just json)


logout : Cmd msg
logout =
    storeCache Nothing


port storeCache : Maybe Value -> Cmd msg



-- SERIALIZATION
-- APPLICATION


application :
    Decoder (Cred -> viewer)
    ->
        { init : Maybe viewer -> Url -> Nav.Key -> ( model, Cmd msg )
        , onUrlChange : Url -> msg
        , onUrlRequest : Browser.UrlRequest -> msg
        , subscriptions : model -> Sub msg
        , update : msg -> model -> ( model, Cmd msg )
        , view : model -> Browser.Document msg
        }
    -> Program Value model msg
application viewerDecoder config =
    let
        init flags url navKey =
            let
                maybeViewer =
                    Decode.decodeValue Decode.string flags
                        |> Result.andThen (Decode.decodeString (storageDecoder viewerDecoder))
                        |> Result.toMaybe
            in
            config.init maybeViewer url navKey
    in
    Browser.application
        { init = init
        , onUrlChange = config.onUrlChange
        , onUrlRequest = config.onUrlRequest
        , subscriptions = config.subscriptions
        , update = config.update
        , view = config.view
        }


storageDecoder : Decoder (Cred -> viewer) -> Decoder viewer
storageDecoder viewerDecoder =
    Decode.field "user" (decoderFromCred viewerDecoder)



-- HTTP


get : Endpoint -> Maybe Cred -> (WebData a -> msg) -> Decoder a -> Cmd msg
get url maybeCred msg decoder =
    Endpoint.request
        { method = "GET"
        , headers =
            case maybeCred of
                Just cred ->
                    [ credHeader cred ]

                Nothing ->
                    []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson (RemoteData.fromResult >> msg) decoder
        , timeout = Nothing
        , tracker = Nothing
        }


put : Endpoint -> Cred -> (Result Http.Error a -> msg) -> Body -> Decoder a -> Cmd msg
put url cred msg body decoder =
    Endpoint.request
        { method = "PUT"
        , headers = [ credHeader cred ]
        , url = url
        , body = body
        , expect = Http.expectJson msg decoder
        , timeout = Nothing
        , tracker = Nothing
        }


post : Endpoint -> Maybe Cred -> (Result Http.Error a -> msg) -> Body -> Decoder a -> Cmd msg
post url maybeCred msg body decoder =
    Endpoint.request
        { method = "POST"
        , headers =
            case maybeCred of
                Just cred ->
                    [ credHeader cred ]

                Nothing ->
                    []
        , url = url
        , body = body
        , expect = Http.expectJson msg decoder
        , timeout = Nothing
        , tracker = Nothing
        }


delete : Endpoint -> Cred -> (Result Http.Error a -> msg) -> Body -> Decoder a -> Cmd msg
delete url cred msg body decoder =
    Endpoint.request
        { method = "DELETE"
        , headers = [ credHeader cred ]
        , url = url
        , body = body
        , expect = Http.expectJson msg decoder
        , timeout = Nothing
        , tracker = Nothing
        }


login : Http.Body -> (Result Http.Error a -> msg) -> Decoder (Cred -> a) -> Cmd msg
login body msg decoder =
    post Endpoint.login Nothing msg body (Decode.field "user" (decoderFromCred decoder))


register : Http.Body -> (Result Http.Error a -> msg) -> Decoder (Cred -> a) -> Cmd msg
register body msg decoder =
    post Endpoint.users Nothing msg body (Decode.field "user" (decoderFromCred decoder))


settings : Cred -> Http.Body -> (Result Http.Error a -> msg) -> Decoder (Cred -> a) -> Cmd msg
settings cred body msg decoder =
    put Endpoint.user cred msg body (Decode.field "user" (decoderFromCred decoder))


decoderFromCred : Decoder (Cred -> a) -> Decoder a
decoderFromCred decoder =
    Decode.map2 (\fromCred cred -> fromCred cred)
        decoder
        credDecoder



-- ERRORS


addServerError : List String -> List String
addServerError list =
    "Server error" :: list


{-| Many API endpoints include an "errors" field in their BadStatus responses.
-}
decodeErrors : Http.Error -> List String
decodeErrors error =
    case error of
        Http.BadBody explanation ->
            [ "The server responded with something unexpected. Reason: " ++ explanation ]

        Http.BadUrl _ ->
            [ "Invalid url" ]

        Http.BadStatus statusCode ->
            [ "Request failed with status code: " ++ String.fromInt statusCode ]

        Http.NetworkError ->
            [ "Unable to reach server." ]

        Http.Timeout ->
            [ "Server is taking too long to respond. Please try again later." ]



-- errorsDecoder : Decoder (List String)
-- errorsDecoder =
--     Decode.keyValuePairs (Decode.list Decode.string)
--         |> Decode.map (List.concatMap fromPair)
-- fromPair : ( String, List String ) -> List String
-- fromPair ( field, errors ) =
--     List.map (\error -> field ++ " " ++ error) errors
