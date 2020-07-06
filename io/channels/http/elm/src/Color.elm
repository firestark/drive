module Color exposing (toCssString)

import Element exposing (Color, toRgb)

toCssString : Color -> String
toCssString color =
    let record = toRgb color
        red = String.fromFloat (record.red * 255)
        green = String.fromFloat (record.green * 255)
        blue = String.fromFloat (record.blue * 255)
        alpha = String.fromFloat 1
    in
        "rgba(" ++ red ++ "," ++ green ++ "," ++ blue ++ "," ++ alpha ++ ")"