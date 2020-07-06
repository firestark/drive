module Material.Button exposing (disabled, raised, text)

import Element exposing (Element, height, paddingXY, px)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Material.Elevation as Elevation 
import Theme exposing (Theme)

text : Theme -> List (Element.Attribute msg) -> String -> Maybe msg -> Element msg
text theme attrs label msg =
    Input.button
        (List.append 
            attrs
            [ height (px 36)
            , Background.color theme.background
            , Font.color theme.primary
            , Font.size 14
            , Font.bold
            , paddingXY 16 0
            , Border.rounded 4
            ])
            { onPress = msg
            , label = Element.text label
            }

raised : Theme -> List (Element.Attribute msg) -> String -> Maybe msg -> Element msg
raised theme attrs label msg =
    Input.button
        (List.append 
            attrs
            [ height (px 36)
            , Background.color theme.primary
            , Font.color theme.onPrimary
            , Font.size 14
            , Font.bold
            , paddingXY 16 0
            , Border.rounded 4
            , Elevation.z2
            ])
            { onPress = msg
            , label = Element.text label
            }

disabled : Theme -> List (Element.Attribute msg) -> String -> Element msg
disabled theme attrs label =
    Input.button
            (List.append
                [ height (px 36)
                , Background.color <| Theme.highlight theme.kind 0.12
                , Font.color <| Theme.highlight theme.kind 0.36
                , Font.size 14
                , Font.bold
                , paddingXY 16 0
                , Border.rounded 4
                , Elevation.z2
                ]
            attrs)
            { onPress = Nothing
            , label = Element.text label
            }