module Main.View exposing (view)

import Main.Colors exposing (blue, cyan, gray, green, orange, red, yellow)
import Main.Model exposing (Model)
import Main.Msg as Msg exposing (Msg)
import UI


view : Model -> ( String, UI.Graphics Msg )
view model =
    ( "Example: HW"
    , UI.column
        [ ( "header", header )
        , ( "events-row", eventsRowExample model )
        , ( "column", columnExample )
        , ( "stack", stackExample )
        , ( "borders", bordersExample )
        , ( "shadow", shadowExample )
        ]
        |> UI.withSpacing 8
        |> UI.withPadding 16
        |> UI.withFontFamilies
            [ "Borg Sans Mono"
            , "Fira Code"
            , "JuliaMono"
            , "Fantasque Sans Mono"
            ]
            UI.monospace
    )


bordersExample : UI.Graphics msg
bordersExample =
    UI.empty
        |> UI.withWidth 25
        |> UI.withHeight 25
        |> UI.withBorder (UI.border1uBlack |> Just)
        |> UI.singleton
        |> UI.withBorder (UI.border1uBlack |> UI.borderWithColor red |> Just)
        |> UI.singleton
        |> UI.withBorder (UI.border1uBlack |> UI.borderWithColor orange |> Just)
        |> UI.singleton
        |> UI.withBorder (UI.border1uBlack |> UI.borderWithColor yellow |> Just)
        |> UI.singleton
        |> UI.withBorder (UI.border1uBlack |> UI.borderWithColor green |> Just)
        |> UI.singleton
        |> UI.withBorder (UI.border1uBlack |> UI.borderWithColor cyan |> Just)
        |> UI.singleton
        |> UI.withBorder (UI.border1uBlack |> UI.borderWithColor blue |> Just)
        |> UI.withAlignSelf UI.center


columnExample : UI.Graphics msg
columnExample =
    UI.indexedColumn
        [ square 0 red
        , square 1 blue
        , square 2 green
        ]
        |> UI.withAlignSelf UI.center


eventsRowExample : Model -> UI.Graphics Msg
eventsRowExample model =
    let
        ifColor pred color_ =
            if pred then
                color_

            else
                gray
    in
    UI.row
        [ ifColor model.square0 red
            |> square 0
            |> UI.withOnClick (Msg.ToggleSquare0 model.square0)
            |> Tuple.pair "red"
        , ifColor model.square1 blue
            |> square 1
            |> UI.withOnClick (Msg.ToggleSquare1 model.square1)
            |> Tuple.pair "blue"
        , ifColor model.square2 green
            |> square 2
            |> UI.withOnClick (Msg.ToggleSquare2 model.square2)
            |> Tuple.pair "green"
        ]


header : UI.Graphics msg
header =
    UI.spanText "Hello World!"
        |> UI.withFontWeight 700
        |> UI.withFontSize 24
        |> UI.withAlignSelf UI.center


shadowExample : UI.Graphics msg
shadowExample =
    UI.empty
        |> UI.withWidth 64
        |> UI.withHeight 64
        |> UI.withBackground (UI.backgroundColor yellow |> Just)
        |> UI.withOuterShadow (UI.shadow1uBlack |> UI.shadowWithLengthXY 6 6 |> Just)
        |> UI.withAlignSelf UI.center


square : Int -> UI.Color -> UI.Graphics msg
square n color =
    UI.empty
        |> UI.withWidth (120 + n * 32)
        |> UI.withHeight (120 + n * 32)
        |> UI.withBackground (UI.backgroundColor color |> Just)
        |> UI.withAlignSelf UI.end


stackExample : UI.Graphics msg
stackExample =
    UI.indexedStack
        [ square 2 red
        , square 1 blue
        , square 0 green
        ]
        |> UI.withJustifyItems UI.center
        |> UI.withAlignSelf UI.center
