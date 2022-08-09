module UI.Backend.CssHelpers exposing (..)

import Hex
import UI.Backend.Graphics exposing (..)


type Units
    = Px


align : Alignment -> String
align alignment =
    case alignment of
        Start ->
            "flex-start"

        Center ->
            "center"

        End ->
            "flex-end"


background : Background -> String
background (Background background_) =
    color background_.color


border : Border -> String
border (Border border_) =
    "solid " ++ color border_.color


borderRadius : { x | units : Units } -> Border -> String
borderRadius config (Border border_) =
    unitsCorners config border_.rounding


borderWidth : { x | units : Units } -> Border -> String
borderWidth config (Border border_) =
    unitsRect config border_.width


color : Color -> String
color (IntRGBA int) =
    "#" ++ String.padLeft 8 '0' (Hex.toString int)


direction : Direction -> Maybe String
direction direction_ =
    case direction_ of
        Horizontal ->
            Just "row"

        Vertical ->
            Just "column"

        Stacked ->
            Nothing


display : MaybeLayout -> Maybe String
display layout =
    if layout.displayDirection /= Nothing || layout.justify /= Nothing then
        Just "flex"

    else
        Nothing


font : ( List String, FontFallback ) -> String
font ( families, fallback ) =
    String.join ", " <| families ++ [ fontFallback fallback ]


fontFallback : FontFallback -> String
fontFallback fallback =
    case fallback of
        SansSerif ->
            "sans-serif"

        Serif ->
            "serif"

        Monospace ->
            "monospace"


inheritable : (a -> String) -> Inheritable a -> String
inheritable encoder inheritable_ =
    case inheritable_ of
        Inherit ->
            "inherit"

        Own value ->
            encoder value


kernel : { x | rootClass : String, stackClass : String, tag : String, units : Units } -> String
kernel ({ rootClass, stackClass, tag } as config) =
    tag ++ """ {
  font-size: inherit;
  font-family: inherit;
  font-weight: inherit;
  color: inherit;
  width: fit-content;
  height: fit-content;
  overflow: clip;
  text-align: start;
  margin: 0;
  padding: 0;
  display: block;
}

""" ++ tag ++ "." ++ rootClass ++ """ {
    font: normal """ ++ units config 16 ++ """ serif;
    color: rgb(0, 0, 0);
}

""" ++ tag ++ "." ++ stackClass ++ " > " ++ tag ++ """ {
    position: absolute;
}

""" ++ tag ++ "." ++ stackClass ++ " > " ++ tag ++ """:first-child {
    position: relative;
}
"""


length : { x | units : Units } -> Length -> String
length config value =
    case value of
        FitContents ->
            "fit-content"

        Units units_ ->
            units config units_


overflow : Overflow -> String
overflow overflow_ =
    case overflow_ of
        Clip ->
            "clip"

        Scrolling _ ->
            "scroll"


shadow : { x | units : Units } -> Shadow -> String
shadow config (Shadow shadow_) =
    String.join " "
        [ units config shadow_.lengthX
        , units config shadow_.lengthY
        , units config shadow_.blurRadius
        , units config shadow_.spreadRadius
        , color shadow_.color
        ]


textAlign : TextAlignment -> String
textAlign alignment =
    case alignment of
        TextLeft ->
            "left"

        TextCenter ->
            "center"

        TextRight ->
            "right"


units : { x | units : Units } -> Int -> String
units config value =
    case config.units of
        Px ->
            String.fromInt value ++ "px"


unitsCorners : { x | units : Units } -> Corners -> String
unitsCorners config corners =
    String.join " "
        [ units config corners.topLeft
        , units config corners.topRight
        , units config corners.bottomRight
        , units config corners.bottomLeft
        ]


unitsRect : { x | units : Units } -> Rect -> String
unitsRect config rect =
    String.join " "
        [ units config rect.top
        , units config rect.right
        , units config rect.bottom
        , units config rect.left
        ]
