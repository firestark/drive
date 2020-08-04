module Material.Dialog exposing (dialog)

import Element exposing (Color, Element, centerX, centerY, column, el, fill, fromRgb, height, mouseOver, paddingXY, paragraph, px, rgb255, row, text, toRgb, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Material.Elevation as Elevation
import Theme exposing (Theme)


dialog : Theme -> msg -> String -> String -> Element msg
dialog theme msg title body =
    column
        [ width fill
        , height fill
        , Element.inFront <| scrim theme msg
        , Element.inFront <| content theme msg title body
        ]
        []


content : Theme -> msg -> String -> String -> Element msg
content theme msg title body =
    column
        [ width (px 330)
        , Background.color theme.surface
        , centerX
        , centerY
        , Elevation.z4
        ]
        [ row
            [ height (px 140)
            , width fill
            , Background.image "/assets/images/material.jpg"
            ]
            [ el
                [ Font.size 24
                , paddingXY 24 24
                , Font.color (rgb255 255 255 255)
                , Element.alignBottom
                ]
              <|
                text title
            ]
        , row [ Font.color (Theme.highlight theme.kind 0.54) ]
            [ paragraph [ Font.size 16, paddingXY 24 24 ]
                [ text body
                ]
            ]
        , buttons msg theme
        ]


scrim : Theme -> msg -> Element msg
scrim theme msg =
    row
        [ width fill
        , height fill
        , Background.color (Theme.highlight theme.kind 0.38)
        , onClick msg
        ]
        []


buttons : msg -> Theme -> Element msg
buttons msg theme =
    row
        [ height (px 52)
        , Element.alignBottom
        , width fill
        , paddingXY 8 0
        ]
        [ Input.button
            [ height (px 36)
            , Font.color theme.primary
            , Font.size 14
            , Font.bold
            , Element.alignRight
            , paddingXY 8 0
            , mouseOver
                [ Background.color <| opaque theme.primary 0.04
                ]
            , Border.rounded 4
            ]
            { onPress = Just msg
            , label = text "UNDERSTOOD"
            }
        ]


opaque : Color -> Float -> Color
opaque color alpha =
    let
        extracted =
            toRgb color
    in
    fromRgb
        { red = extracted.red
        , green = extracted.green
        , blue = extracted.blue
        , alpha = alpha
        }
