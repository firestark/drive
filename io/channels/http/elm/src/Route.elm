module Route exposing (Route(..), fromUrl, href, replaceUrl, routeToString)

import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, oneOf, s)



-- ROUTING


type Route
    = Login
    | Logout
    | Register
    | QuestList


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map QuestList Parser.top
        , Parser.map Login (s "login")
        , Parser.map Logout (s "logout")
        , Parser.map Register (s "register")
        ]



-- PUBLIC HELPERS


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (routeToString route)


fromUrl : Url -> Maybe Route
fromUrl url =
    -- The RealWorld spec treats the fragment like a path.
    -- This makes it *literally* the path, so we can proceed
    -- with parsing as if it had been a normal path all along.
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse parser



-- INTERNAL


routeToString : Route -> String
routeToString page =
    "/#/" ++ String.join "/" (routeToPieces page)


routeToPieces : Route -> List String
routeToPieces page =
    case page of
        QuestList ->
            []

        Login ->
            [ "login" ]

        Logout ->
            [ "logout" ]

        Register ->
            [ "register" ]
