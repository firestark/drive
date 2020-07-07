module Material.Dialog exposing (dialog)

import Element exposing (Element, centerX, centerY, column, el, fill, height, paddingXY, paragraph, px, rgb255, row, text, width)
import Element.Background as Background
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Material.Elevation as Elevation
import Theme exposing (Theme)


dialog : Theme -> msg -> String -> String -> Element msg
dialog theme msg title body =
    row
        [ width fill
        , height fill
        , Background.color (Theme.highlight theme.kind 0.38)
        , onClick msg
        , Element.inFront <|
            column
                [ width (px 330)
                , height (px 324)
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
                , buttons theme
                ]
        ]
        []


buttons : Theme -> Element msg
buttons theme =
    row
        [ height (px 52)
        , Element.alignBottom
        , width fill
        ]
        [ Input.button
            [ Font.color theme.primary
            , Font.size 14
            , Font.bold
            , Element.alignRight
            , paddingXY 16 0
            ]
            { onPress = Nothing
            , label = text "UNDERSTOOD"
            }
        ]
