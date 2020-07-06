module Material.List exposing (Item, icon, link, singleElement, singleLine, text, threeLine)

import Element exposing (Element, centerY, column, el, fill, height, link, mouseOver, paddingXY, px, rgba255, row, spacing, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Material.Icons
import Theme exposing (Theme)


type alias Item =
    { first : String
    , second : String
    , url : Maybe String
    }


singleLine : Theme -> List Item -> Element msg
singleLine theme items =
    column
        [ width fill
        , Font.color theme.onBackground
        , paddingXY 0 8
        ]
    <|
        List.map (element theme) items


element : Theme -> Item -> Element msg
element theme item =
    case item.url of
        Nothing ->
            singleElement
                []
                [ icon theme [] Material.Icons.check
                , text theme item.first
                ]

        Just url ->
            link theme
                url
                (singleElement
                    []
                    [ icon theme [] Material.Icons.check
                    , text theme item.first
                    ]
                )


singleElement : List (Element.Attribute msg) -> List (Element msg) -> Element msg
singleElement attrs elements =
    row
        (List.append
            [ width fill
            , height (px 56)
            , Font.size 16
            , centerY
            ]
            attrs
        )
        [ row
            [ width fill
            , height fill
            , spacing 24
            ]
            elements
        ]


icon : Theme -> List (Element.Attribute msg) -> Element msg -> Element msg
icon theme attrs icon_ =
    el
        (List.append
            [ height (px 40)
            , width (px 40)
            , Element.paddingEach
                { top = 8
                , right = 8
                , bottom = 8
                , left = 8
                }
            , Font.color <| Theme.highlight theme.kind 0.44
            , Background.color (rgba255 255 255 255 0.1)
            , Border.rounded 50
            , Element.clip
            ]
            attrs
        )
    <|
        el
            [ centerY
            ]
            icon_


text : Theme -> String -> Element msg
text theme txt =
    el
        [ height fill
        , width fill
        , Element.paddingEach
            { top = 0
            , right = 16
            , bottom = 0
            , left = 0
            }
        , Border.widthEach
            { bottom = 1
            , left = 0
            , right = 0
            , top = 0
            }
        , Border.color <| Theme.highlight theme.kind 0.12
        ]
    <|
        el
            [ Element.centerY
            ]
        <|
            Element.text txt



-- three line lists


threeLine : Theme -> List Item -> Element msg
threeLine theme items =
    column
        [ width fill
        , Font.color theme.onBackground
        , Element.paddingEach
            { bottom = 8
            , left = 16
            , right = 0
            , top = 8
            }
        ]
    <|
        List.map (threeLineElement theme) items


threeLineElement : Theme -> Item -> Element msg
threeLineElement theme item =
    case item.url of
        Nothing ->
            threeElement theme item.first item.second

        Just url ->
            link theme url (threeElement theme item.first item.second)


threeElement : Theme -> String -> String -> Element msg
threeElement theme text1 text2 =
    row
        [ width fill, spacing 32 ]
        [ icon theme [] Material.Icons.check
        , row
            [ width fill
            , height (px 88)
            , Element.spacingXY 0 4
            , Border.widthEach
                { bottom = 1
                , left = 0
                , right = 0
                , top = 0
                }
            , Border.color <| Theme.highlight theme.kind 0.12
            , spacing 8
            ]
            [ column
                [ width fill, spacing 4 ]
                [ row
                    [ width fill
                    , Font.size 16
                    , centerY
                    ]
                    [ el
                        [ Element.centerY
                        ]
                      <|
                        Element.text text1
                    ]
                , row
                    [ width fill
                    , Font.size 14
                    , Font.color <| Theme.highlight theme.kind 0.54
                    , centerY
                    ]
                    [ el
                        [ Element.centerY
                        , width fill
                        ]
                      <|
                        Element.paragraph [ width fill ]
                            [ Element.text text2 ]
                    ]
                ]
            , column
                [ height fill
                , Element.paddingEach
                    { bottom = 8
                    , left = 0
                    , right = 16
                    , top = 16
                    }
                ]
                [ Element.el [ Element.alignRight, Element.alignTop, Font.color (Theme.highlight theme.kind 0.54) ] Material.Icons.info
                , Element.el [ Element.alignRight, Element.alignBottom, Font.size 12, Font.color (Theme.highlight theme.kind 0.54) ] <| Element.text "5 min"
                ]
            ]
        ]


link : Theme -> String -> Element msg -> Element msg
link theme url el =
    Element.el [ width fill ] <|
        Element.link
            [ width fill
            , Element.pointer
            , Element.focused
                [ Background.color <| Theme.highlight theme.kind 0.12
                ]
            , Element.mouseDown
                [ Background.color <| Theme.highlight theme.kind 0.16
                ]
            , mouseOver
                [ Background.color <| Theme.highlight theme.kind 0.04
                ]
            ]
            { url = url
            , label = el
            }
