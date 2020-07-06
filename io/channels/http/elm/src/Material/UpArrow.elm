module Material.UpArrow exposing (UpArrow(..), view)

import Element exposing (Element, el, link, paddingEach)
import Element.Events exposing (onClick)
import Material.Icons as Icon
import Route exposing (Route)


type UpArrow msg
    = Route Route
    | Action msg

view : UpArrow msg -> Element msg
view upArrow =
    case upArrow of
       Route route -> link route
       Action msg -> action msg


link : Route -> Element msg
link route =
    Element.link
        [ padding, Element.pointer ]
        { url = Route.routeToString route
        , label = 
            el 
                [] 
                Icon.arrow_back
        }

action : msg -> Element msg
action msg =
    el
        [ padding
        , Element.pointer
        , onClick msg
        ] Icon.arrow_back


padding : Element.Attribute msg
padding =
    paddingEach
        { top = 0
        , right = 20
        , bottom = 0
        , left = 0
        }