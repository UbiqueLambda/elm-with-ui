module Main.Colors exposing (blue, cyan, gray, green, orange, red, yellow)

import UI


blue : UI.Color
blue =
    UI.intRGBA 0xFFFF


cyan : UI.Color
cyan =
    UI.intRGBA 0x00FFFFFF


gray : UI.Color
gray =
    UI.intRGBA 0xAAAAAAFF


green : UI.Color
green =
    UI.intRGBA 0x00FF00FF


orange : UI.Color
orange =
    UI.intRGBA 0xFFA500FF


red : UI.Color
red =
    UI.intRGBA 0xFF0000FF


yellow : UI.Color
yellow =
    UI.intRGBA 0xFFFF00FF
