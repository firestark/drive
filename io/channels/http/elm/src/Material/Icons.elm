module Material.Icons exposing (account_circle, add, add_circle, arrow_back, check, delete, edit, highlight, info, lock, play_arrow, save, search, visibility)

import Element exposing (Element)
import Svg exposing (g, rect, svg)
import Svg.Attributes exposing (d, enableBackground, fill, height, viewBox, width)


account_circle : Element msg
account_circle =
    Element.html <|
        svg
            [ height "24", viewBox "0 0 24 24", width "24", fill "currentColor" ]
            [ Svg.path [ d "M0 0h24v24H0z", fill "none" ] []
            , Svg.path [ d "M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 3c1.66 0 3 1.34 3 3s-1.34 3-3 3-3-1.34-3-3 1.34-3 3-3zm0 14.2c-2.5 0-4.71-1.28-6-3.22.03-1.99 4-3.08 6-3.08 1.99 0 5.97 1.09 6 3.08-1.29 1.94-3.5 3.22-6 3.22z" ] []
            ]


add : Element msg
add =
    Element.html <|
        svg
            [ height "24", viewBox "0 0 24 24", width "24", fill "currentColor" ]
            [ Svg.path [ d "M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z" ] []
            , Svg.path [ d "M0 0h24v24H0z", fill "none" ] []
            ]


add_circle : Element msg
add_circle =
    Element.html <|
        svg
            [ height "24", viewBox "0 0 24 24", width "24", fill "currentColor" ]
            [ Svg.path [ d "M0 0h24v24H0z", fill "none" ] []
            , Svg.path [ d "M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm5 11h-4v4h-2v-4H7v-2h4V7h2v4h4v2z" ] []
            ]


arrow_back : Element msg
arrow_back =
    Element.html <|
        svg [ width "24", height "24", viewBox "0 0 24 24", fill "currentColor" ]
            [ Svg.path [ fill "none", d "M0 0h24v24H0V0z" ] []
            , Svg.path
                [ d """M19 11H7.83l4.88-4.88c.39-.39.39-1.03 0-1.42-.39-.39-1.02-.39-1.41 0l-6.59 6.59c-.39.39-.39 1.02 
                    0 1.41l6.59 6.59c.39.39 1.02.39 1.41 
                    0 .39-.39.39-1.02 0-1.41L7.83 13H19c.55 0 1-.45 1-1s-.45-1-1-1z""" ]
                []
            ]


check : Element msg
check =
    Element.html <|
        svg
            [ height "24", viewBox "0 0 24 24", width "24", fill "currentColor" ]
            [ Svg.path [ d "M0 0h24v24H0z", fill "none" ] []
            , Svg.path [ d "M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" ] []
            ]


delete : Element msg
delete =
    Element.html <|
        svg [ height "24", viewBox "0 0 24 24", width "24", fill "currentColor" ]
            [ Svg.path [ d "M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z" ] []
            , Svg.path [ d "M0 0h24v24H0z", fill "none" ] []
            ]


edit : Element msg
edit =
    Element.html <|
        svg
            [ height "24", viewBox "0 0 24 24", width "24", fill "currentColor" ]
            [ Svg.path [ d """M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 
            0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z""" ] []
            , Svg.path [ d "M0 0h24v24H0z", fill "none" ] []
            ]


highlight : Element msg
highlight =
    Element.html <|
        svg
            [ enableBackground "new 0 0 24 24", height "24", width "24", viewBox "0 0 24 24", fill "currentColor" ]
            [ g [] [ rect [ fill "none", height "24", width "24" ] [] ]
            , g []
                [ g []
                    [ g []
                        [ Svg.path
                            [ d """M6,14l3,3v5h6v-5l3-3V9H6V14z M11,2h2v3h-2V2z M3.5,5.88l1.41-1.41l2.12,2.12L5.62,8L3.5,5.88z 
                    M16.96,6.59l2.12-2.12 l1.41,1.41L18.38,8L16.96,6.59z"""
                            ]
                            []
                        ]
                    ]
                ]
            ]


info : Element msg
info =
    Element.html <|
        svg [ height "24", viewBox "0 0 24 24", width "24", fill "currentColor" ]
            [ Svg.path [ d "M0 0h24v24H0z", fill "none" ] []
            , Svg.path [ d "M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z" ] []
            ]


lock : Element msg
lock =
    Element.html <|
        svg [ height "24", viewBox "0 0 24 24", width "24", fill "currentColor" ]
            [ Svg.path [ d "M0 0h24v24H0z", fill "none" ] [], Svg.path [ d "M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z" ] [] ]


play_arrow : Element msg
play_arrow =
    Element.html <|
        svg
            [ height "24", viewBox "0 0 24 24", width "24", fill "currentColor" ]
            [ Svg.path [ d "M8 5v14l11-7z" ] [], Svg.path [ d "M0 0h24v24H0z", fill "none" ] [] ]


save : Element msg
save =
    Element.html <|
        svg
            [ height "24", viewBox "0 0 24 24", width "24", fill "currentColor" ]
            [ Svg.path [ d "M0 0h24v24H0z", fill "none" ] []
            , Svg.path [ d """M17 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V7l-4-4zm-5 
                        16c-1.66 0-3-1.34-3-3s1.34-3 3-3 3 1.34 3 3-1.34 3-3 3zm3-10H5V5h10v4z""" ] []
            ]


search : Element msg
search =
    Element.html <|
        svg [ height "24", viewBox "0 0 24 24", width "24", fill "currentColor" ]
            [ Svg.path [ d "M0 0h24v24H0z", fill "none" ] []
            , Svg.path [ d "M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z" ] []
            ]


visibility : Element msg
visibility =
    Element.html <|
        svg [ height "24", viewBox "0 0 24 24", width "24", fill "currentColor" ]
            [ Svg.path [ d "M0 0h24v24H0z", fill "none" ] [], Svg.path [ d "M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z" ] [] ]
