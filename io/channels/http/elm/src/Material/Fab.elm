module Material.Fab exposing (bottomRight, regular)

import Element exposing (Element, el, clip, width, height, px, centerX, centerY, mouseOver, fill)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Material.Elevation as Elevation
import Html.Attributes
import Theme exposing (Theme)

-- regular : Theme -> Element msg -> Route -> Element msg
-- regular theme icon route =
--     link 
--         bottomRight
--         { url = Route.routeToString route
--         , label = fab theme icon
--         }

regular : Theme -> Element msg -> Element msg
regular theme icon =
    el 
        [ Border.rounded 50 
        , clip
        , Background.color theme.secondary
        , Font.color theme.onSecondary
        , width (px 56)
        , Element.height (px 56)
        , Elevation.z6
        , Element.inFront 
        <| el 
            [ width fill
            , height fill
            , mouseOver 
                [ Background.color <| Element.rgba255 255 255 255 0.14
                ]
            ] 
            (Element.text "")
        ]
        <| el 
            [ centerX
            , centerY
            ] 
            icon


-- Position

bottomRight : List (Element.Attribute msg)
bottomRight =
    [ Element.htmlAttribute <| 
        Html.Attributes.style "position" "fixed"
    , Element.htmlAttribute <| 
        Html.Attributes.style "bottom" "16px"
    , Element.htmlAttribute <| 
            Html.Attributes.style "right" "16px"
    ]