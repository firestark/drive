module Route exposing (Route(..), fromUrl, replaceUrl, toString)

import Browser.Navigation as Nav
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, oneOf, s)



-- ROUTING


type Route
    = AddQuest
    | Completions
    | Logout
    | QuestList


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map QuestList Parser.top
        , Parser.map AddQuest (s "add")
        , Parser.map Completions (s "completions")
        , Parser.map Logout (s "logout")
        ]



-- PUBLIC HELPERS


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (toString route)


fromUrl : Url -> Maybe Route
fromUrl url =
    -- The RealWorld spec treats the fragment like a path.
    -- This makes it *literally* the path, so we can proceed
    -- with parsing as if it had been a normal path all along.
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse parser



-- INTERNAL


toString : Route -> String
toString page =
    "/#/" ++ String.join "/" (routeToPieces page)


routeToPieces : Route -> List String
routeToPieces page =
    case page of
        AddQuest ->
            [ "add" ]

        Completions ->
            [ "completions" ]

        Logout ->
            [ "logout" ]

        QuestList ->
            []
