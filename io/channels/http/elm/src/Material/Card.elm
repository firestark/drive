module Material.Card exposing (view)

import Element exposing (Element, width, fill, column)
import Element.Background as Background
import Element.Font as Font
import Material.Elevation as Elevation
import Theme exposing (Theme)


view : Theme -> List (Element msg) -> Element msg
view theme elements =
    column 
        [ Elevation.z1
        , width fill
        , Background.color theme.surface
        , Font.color theme.onSurface
        ] 
        elements