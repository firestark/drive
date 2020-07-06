module Material.TopAppBar exposing (elevation, iconButton, row, title)

import Element exposing (Attribute, Element, alignRight, el, fill, height, paddingXY, pointer, px, text, width)
import Element.Background as Background
import Element.Font as Font
import Material.Elevation as Elevation
import Theme exposing (Theme)

row : Theme -> List (Element msg) -> Element msg
row theme elements =
    Element.row
        [ width fill
        , height (px 64)
        , paddingXY 16 12
        , Background.color theme.primary
        , Font.color theme.onPrimary
        , elevation
        ]
        elements

title : String -> Element msg
title txt =
    el
        [ Font.size 20
        , Font.semiBold
        ]
        (text txt)

iconButton : List (Attribute msg) -> Element msg -> Element msg
iconButton attributes icon =
    el  
        (attributes ++
        [ pointer
        , alignRight
        ])
        icon

elevation : Element.Attribute msg
elevation =
    Elevation.z6