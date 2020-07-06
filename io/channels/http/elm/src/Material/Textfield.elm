module Material.Textfield exposing (Config, regular, transparent)

import Color
import Element exposing (Color, Element, column, width, fill, height, el, px, focused, paddingEach)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import Theme exposing (Theme)

type alias Config msg =
    { value : String
    , label : String
    , error : Maybe String
    , onInput : String -> msg
    }

regular : Theme -> Config msg -> Element msg
regular theme config =
    column [ width fill, Element.spacingXY 0 4 ] 
        [ column 
            [ height (px 56)
            , width fill
            , Border.roundEach 
                { topLeft = 4
                , topRight = 4
                , bottomLeft = 0
                , bottomRight = 0
                }
            , Background.color <| Theme.highlight theme.kind 0.04
            , Element.inFront <| textfieldInput theme config
            ] 
            [],
            assistiveText theme config.error
        ]

assistiveText : Theme -> Maybe String -> Element msg
assistiveText theme error =
    case error of
        Nothing -> 
            el 
            [ Font.size 13
            , Font.medium
            ] <| Element.text " "
        Just errorMsg ->
            el 
            [ Font.size 13
            , Font.color theme.error
            , Font.medium
            ] <| Element.text errorMsg


textfieldInput : Theme -> Config msg -> Element msg
textfieldInput theme { label, value, error, onInput } =
    Input.text 
        [ height fill
        , width fill
        , Background.color <| Element.rgba255 0 0 0 0
        , Font.color <| theme.onSurface
        , Font.size 16
        , Element.paddingEach
            { top = 0
            , right = 16
            , bottom = 0
            , left = 16
            }
        , Element.spacingXY 0 4
        , Border.widthEach 
            { bottom = 2
            , left = 0
            , right = 0
            , top = 0
            }
        , Border.roundEach 
            { topLeft = 4
            , topRight = 4
            , bottomLeft = 0
            , bottomRight = 0
            }
        , Border.color <| borderColor theme error
        , focused 
            [ Border.color <| borderFocusColor theme error
            ]
        , carretColor theme error
        ]
        { onChange = onInput
        , text = value
        , placeholder = Nothing
        , label = 
            Input.labelAbove 
                [ Element.paddingEach
                    { top = 8
                    , right = 16
                    , bottom = 0
                    , left = 16
                    }
                ] <| 
                el 
                    [ Font.color <| labelColor theme error
                    , Font.size 14
                    ] 
                (Element.text label)
        }

transparent : Theme -> Config msg -> Element msg
transparent theme config =
    column 
        [ height (px 56)
        , width fill
        , Element.alignTop
        , Border.roundEach 
            { topLeft = 4
            , topRight = 4
            , bottomLeft = 0
            , bottomRight = 0
            }
        , Background.color <| Element.rgba255 255 255 255 0.44
        , Element.inFront <| textfieldInputTransparent theme config
        ] 
        [ 
        ]

textfieldInputTransparent : Theme -> Config msg -> Element msg
textfieldInputTransparent theme { value, label, error, onInput } =
    Input.text 
        [ height fill
        , width fill
        , Background.color <| Element.rgba255 0 0 0 0
        , Font.color <| theme.onPrimary
        , Font.size 16
        , Element.paddingEach
            { top = 0
            , right = 16
            , bottom = 0
            , left = 16
            }
        , Element.spacingXY 0 4
        , Border.widthEach 
            { bottom = 2
            , left = 0
            , right = 0
            , top = 0
            }
        , Border.roundEach 
            { topLeft = 4
            , topRight = 4
            , bottomLeft = 0
            , bottomRight = 0
            }
        , Border.color <| borderColor theme error
        , focused 
            [ Border.color <| borderFocusColor theme error
            ]
        , carretColor theme error
        ]
        { onChange = onInput
        , text = value
        , placeholder = Nothing
        , label = 
            Input.labelAbove 
                [ Element.paddingEach
                    { top = 8
                    , right = 16
                    , bottom = 0
                    , left = 16
                    }
                ] <| 
                el 
                    [ Font.color <| labelColorTransparent theme error
                    , Font.size 14
                    ] 
                (Element.text label)
        }

------------------------------------------------------------------------------------
-- Colors
------------------------------------------------------------------------------------

carretColor : Theme -> Maybe String -> Element.Attribute msg
carretColor theme error =
    let color = case error of
            Nothing -> theme.primary
            Just _ -> theme.error
    in
        Element.htmlAttribute <| 
            Html.Attributes.style "caret-color" (Color.toCssString color)

labelColor : Theme -> Maybe String -> Color
labelColor theme error =
    case error of
        Nothing -> Theme.highlight theme.kind 0.4
        Just _ -> theme.error

labelColorTransparent : Theme -> Maybe String -> Color
labelColorTransparent theme error =
    case error of
        Nothing -> Element.rgba255 255 255 255 0.72
        Just _ -> theme.error

borderColor : Theme -> Maybe String -> Color
borderColor theme error =
    case error of
        Nothing -> Theme.highlight theme.kind 0.24
        Just _ -> theme.error

borderFocusColor : Theme -> Maybe String -> Color
borderFocusColor theme error =
    case error of
        Nothing -> theme.onPrimary
        Just _ -> theme.error