module UI exposing
    ( Graphics, map
    , Color, intRGBA
    , Rect, Corners
    , empty, looseText, spanText
    , singleton, row, column, stack, indexedRow, indexedColumn, indexedStack
    , withWidth, withFitContentsX, withHeight, withFitContentsY
    , withSpacing, withPadding, withPaddingXY, withPaddingEach
    , withScrollingX, withScrollingY, Scroll, scrollInsetAlwaysVisible
    , withBackground, Background, backgroundColor
    , withBorder, Border, border1uBlack, borderWithColor
    , borderWithWidth, borderWithWidthXY, borderWithWidthEach
    , borderWithRounding, borderWithRoundingEach
    , withOuterShadow, Shadow, shadow1uBlack, shadowWithColor, shadowWithLengthXY, shadowWithBlurRadius, shadowWithSpreadRadius
    , withTextAlign, TextAlignment, textLeft, textCenter, textRight
    , withAlignSelf, withJustifyItems, Alignment, start, center, end
    , withFontColor, withFontSize, withFontWeight
    , withFontFamilies, FontFallback, serif, sansSerif, monospace
    , withInheritFontFamilies, withInheritFontColor, withInheritFontSize, withInheritFontWeight
    , withOnClick
    , toElmHtml, ElmHtmlEncoder, elmHtmlInit
    )

{-| With-pattern UI toolkit for Elm. Oversimplified by now.

In this documentant, the world `unit` meaning varies according to your Encoder.


# Type

@docs Graphics, map


## Color type

@docs Color, intRGBA


## Helping types

@docs Rect, Corners


## Atoms

@docs empty, looseText, spanText


## Grouping

@docs singleton, row, column, stack, indexedRow, indexedColumn, indexedStack


# Options


## Change Width and Height

@docs withWidth, withFitContentsX, withHeight, withFitContentsY


## Change Spacing and Padding

@docs withSpacing, withPadding, withPaddingXY, withPaddingEach


## Scrolling Behavior

@docs withScrollingX, withScrollingY, Scroll, scrollInsetAlwaysVisible


## Background

@docs withBackground, Background, backgroundColor


## Borders

@docs withBorder, Border, border1uBlack, borderWithColor

@docs borderWithWidth, borderWithWidthXY, borderWithWidthEach

@docs borderWithRounding, borderWithRoundingEach


## Shadows

@docs withOuterShadow, Shadow, shadow1uBlack, shadowWithColor, shadowWithLengthXY, shadowWithBlurRadius, shadowWithSpreadRadius


## Text Alignment

@docs withTextAlign, TextAlignment, textLeft, textCenter, textRight


## Item Alignment

@docs withAlignSelf, withJustifyItems, Alignment, start, center, end


## Font Adjustments

@docs withFontColor, withFontSize, withFontWeight

@docs withFontFamilies, FontFallback, serif, sansSerif, monospace

@docs withInheritFontFamilies, withInheritFontColor, withInheritFontSize, withInheritFontWeight


## Events

@docs withOnClick


# Rendering

@docs toElmHtml, ElmHtmlEncoder, elmHtmlInit

-}

import Html exposing (Html)
import UI.Backend.Graphics as Backend
import UI.Backend.Html as Html


{-| Type for describing atoms or groups.
-}
type alias Graphics msg =
    Backend.Graphics msg


{-| Type for holding color primitives.
-}
type alias Color =
    Backend.Color


{-| Helper type for grouping top, right, bottom, and left distances (in units).
-}
type alias Rect =
    { top : Int, right : Int, bottom : Int, left : Int }


{-| Helper type for grouping topLeft, topRight, bottomRight, and bottomLeft metrics (in units).
-}
type alias Corners =
    { topLeft : Int, topRight : Int, bottomRight : Int, bottomLeft : Int }


{-| Type for the possible options of scrolling.
-}
type alias Scroll =
    Backend.Scroll


{-| Type for the possible backgrounds types.
-}
type alias Background =
    Backend.Background


{-| Type for describing border displaying.
-}
type alias Border =
    Backend.Border


{-| Type for the describing shadow displaying.
-}
type alias Shadow =
    Backend.Shadow


{-| Type for the possible options of text alignemtn.
-}
type alias TextAlignment =
    Backend.TextAlignment


{-| Type for the possible alignment positions.
-}
type alias Alignment =
    Backend.Alignment


{-| Type for the possible font fallbacks.
-}
type alias FontFallback =
    Backend.FontFallback


{-| Types that describes and configures the encoding to Elm-compatible HTML.
-}
type alias ElmHtmlEncoder =
    Html.Encoder


{-| Usually used for nesting components.

    dropdownView model =
        UI.map ForDropdownMsg (MyDropdown.view model.dropdown)

-}
map : (a -> msg) -> Graphics a -> Graphics msg
map =
    Backend.map


{-| Use 32-bit hexadecimal to describe the RGBA color.

red = intRGBA 0xFF0000FF
yellow = intRGBA 0xFFFF00FF
cyan = intRGBA 0x00FFFFFF

-}
intRGBA : Int -> Color
intRGBA =
    Backend.intRGBA


{-| Empty figure.
-}
empty : Graphics msg
empty =
    Backend.empty


{-| Text without a container. Don't have any special behavior, it just renders.

In HTML, this will insert text in the document without surrouding it in a tag.

**NOTE**: When you use any [with\* function](#Options) in a loose-text, it automatically wraps in a [`singleton`](#singleton).
The result is then identical to a [`spanText`](#spanText).

-}
looseText : String -> Graphics msg
looseText =
    Backend.looseText


{-| Wraps text within a container. Behaves according to the parent grouping disposition.

In HTML, this will insert text in the document without surrouding it in a `<div>` tag.

-}
spanText : String -> Graphics msg
spanText =
    Backend.spanText


{-| Wraps a single element in a container.

    nestedSquares =
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

-}
singleton : Graphics msg -> Graphics msg
singleton =
    Backend.singleton


{-| Group itens disposing them horizontally.

    pageView model =
        [ ( "contents", contentsView model )
        , ( "tools", toolingView model )
        ]
            |> maybePrependSidebar model
            |> UI.row

-}
row : List ( String, Graphics msg ) -> Graphics msg
row =
    Backend.row


{-| Group itens disposing them vertically.

    shopList model =
        [ ( "pineapple", pineappleBox )
        , ( "rice", riceBox )
        , ( "onions", onionsBox )
        ]
            |> maybePrependBeans model
            |> UI.column

-}
column : List ( String, Graphics msg ) -> Graphics msg
column =
    Backend.column


{-| Group itens disposing them one above the other. Head goes on bottom, tails goes on top.

    pageView model =
        [ ( "contents", pageContents ) ]
            |> maybeAppendHalfOpaqueBlackOverlay model
            |> maybeAppendDialogBox
            |> UI.stack

-}
stack : List ( String, Graphics msg ) -> Graphics msg
stack =
    Backend.stack


{-| This is like [`row`](#row), but the virtual-dom struggles to know what to recreate and what to update.
It should be fine when you group elements that don't disappear, don't decrease in number, don't increment, and don't swap their order.

**TL;DR**: Avoid this.

    tabsMenu =
        UI.indexedRow
            [ codeTab
            , issuesTab
            , prTab
            , wikiTab
            , settingsTab
            ]

-}
indexedRow : List (Graphics msg) -> Graphics msg
indexedRow =
    Backend.indexedRow


{-| This is like [`column`](#column), but the virtual-dom struggles to know what to recreate and what to update.
It should be fine when you group elements that don't disappear, don't decrease in number, don't increment, and don't swap their order.

**TL;DR**: Avoid this.

    pageView =
        UI.indexedColumn
            [ header
            , text
            , footer
            ]

-}
indexedColumn : List (Graphics msg) -> Graphics msg
indexedColumn =
    Backend.indexedColumn


{-| This is like [`stack`](#stack), but the virtual-dom struggles to know what to recreate and what to update.
It should be fine when you group elements that don't disappear, don't decrease in number, don't increment, and don't swap their order.

**TL;DR**: Avoid this.

    tabsMenu =
        UI.indexedStack
            [ pageContents
            , halfOpaqueBlackOverlay
            , dialogBox
            ]

-}
indexedStack : List (Graphics msg) -> Graphics msg
indexedStack =
    Backend.indexedStack


{-| Forces the group's width to a quantity in units.

By default, if the children's length is bigger, the content is cliped.
See [`withScrollingX`](#withScrollingX) to avoid it.

    someSquare =
        UI.empty
            |> UI.withWidth 64
            |> UI.withHeight 64
            |> UI.withBackground (UI.backgroundColor blue |> Just)

-}
withWidth : Int -> Graphics msg -> Graphics msg
withWidth =
    Backend.withWidth


{-| Instead of forcing the width, have enougth to show all the children contents.

For forcing a fixed one, see [`withWidth`](#withWidth).

-}
withFitContentsX : Graphics msg -> Graphics msg
withFitContentsX =
    Backend.withFitContentsX


{-| Forces the group's height to a quantity in units.

By default, if the children's length is bigger, the content is cliped.
See [`withScrollingY`](#withScrollingY) to avoid it.

    someSquare =
        UI.empty
            |> UI.withWidth 64
            |> UI.withHeight 64
            |> UI.withBackground (UI.backgroundColor blue |> Just)

-}
withHeight : Int -> Graphics msg -> Graphics msg
withHeight =
    Backend.withHeight


{-| Instead of forcing the height, have enougth to show all the children contents.

For forcing a fixed one, see [`withHeight`](#withHeight).

-}
withFitContentsY : Graphics msg -> Graphics msg
withFitContentsY =
    Backend.withFitContentsY


{-| Empty space between the items of a group, in units.

    spacedRow =
        UI.row [ item1, item2, item3 ]
            |> UI.withSpacing 8

-}
withSpacing : Int -> Graphics msg -> Graphics msg
withSpacing =
    Backend.withSpacing


{-| Applies empty space, in units, repeatedly on top, bottom, left and right, surrounding the group.

    square =
        UI.spanText "Hello World!"
            |> UI.withPadding 12
            |> UI.withBorder (UI.border1uBlack |> Just)

-}
withPadding : Int -> Graphics msg -> Graphics msg
withPadding =
    Backend.withPadding


{-| Applies empty space, in units, to X (left and right) and Y (top and bottom).

    square =
        UI.spanText "Hello World!"
            |> UI.withPaddingEach { top = 1, right = 3, bottom = 4, left = 2 }
            |> UI.withBorder (UI.border1uBlack |> Just)

-}
withPaddingXY : Int -> Int -> Graphics msg -> Graphics msg
withPaddingXY =
    Backend.withPaddingXY


{-| Applies empty space, in units, surrounding the group.

    square =
        UI.spanText "Hello World!"
            |> UI.withPaddingEach { top = 1, right = 3, bottom = 4, left = 2 }
            |> UI.withBorder (UI.border1uBlack |> Just)

-}
withPaddingEach : Rect -> Graphics msg -> Graphics msg
withPaddingEach =
    Backend.withPaddingEach


{-| When the contents of a group does not fit into the group's width, you might want to show a horizontal scroll bar.

See [`scrollInsetAlwaysVisible`](#scrollInsetAlwaysVisible) for the only value available right now.
`Nothing` means the content will be horizontally clipped (default behavior).

    horizontalScrollbars items =
        UI.row items
            |> UI.withPadding 16
            |> UI.withScrollingX (Just UI.scrollInsetAlwaysVisible)

-}
withScrollingX : Maybe Scroll -> Graphics msg -> Graphics msg
withScrollingX =
    Backend.withScrollingX


{-| When the contents of a group does not fit into the group's height, you might want to show a vertical scroll bar.

See [`scrollInsetAlwaysVisible`](#scrollInsetAlwaysVisible) for the only value available right now.
`Nothing` means the content will be vertically clipped (default behavior).

    verticalScrollbars items =
        UI.column items
            |> UI.withPadding 16
            |> UI.withScrollingY (Just UI.scrollInsetAlwaysVisible)

-}
withScrollingY : Maybe Scroll -> Graphics msg -> Graphics msg
withScrollingY =
    Backend.withScrollingY


{-| The (default) HTML-like way of adding scrollbars to any group.

The scrollbar is inset, relative to the group's dimensions.
And is always visible indiferent to the length of the group's contents.

See [`withScrollingX`](#withScrollingX) and [`withScrollingY`](#withScrollingY) for usage.

-}
scrollInsetAlwaysVisible : Scroll
scrollInsetAlwaysVisible =
    Backend.scrollInsetAlwaysVisible


{-| Applies a background to an element.

    square =
        UI.empty
            |> UI.withWidth 32
            |> UI.withHeight 32
            |> UI.withBackground (UI.backgroundColor black |> Just)

-}
withBackground : Maybe Background -> Graphics msg -> Graphics msg
withBackground =
    Backend.withBackground


{-| Creates a background and fills it with a specific color.

    green =
        UI.intRGBA 0x00FF00FF

    greenSquare =
        UI.empty
            |> UI.withWidth 32
            |> UI.withHeight 32
            |> UI.withBackground (UI.backgroundColor green |> Just)

-}
backgroundColor : Color -> Background
backgroundColor =
    Backend.backgroundColor


{-| Applies borders to an element.

    square =
        UI.empty
            |> UI.withWidth 32
            |> UI.withHeight 32
            |> UI.withBorder (UI.border1uBlack |> Just)

-}
withBorder : Maybe Border -> Graphics msg -> Graphics msg
withBorder =
    Backend.withBorder


{-| Creates a border with 1 unit on each side, solid and black.

    emptySquare =
        UI.empty
            |> UI.withWidth 31
            |> UI.withHeight 31
            |> UI.withBorder (UI.border1uBlack |> Just)

-}
border1uBlack : Border
border1uBlack =
    Backend.border1uBlack


{-| Changes the color of all sides of the border.

    pink =
        UI.intRGBA 0xFFC0CBFF

    emptySquare =
        UI.empty
            |> UI.withWidth 31
            |> UI.withHeight 31
            |> UI.withBorder (UI.border1uBlack |> UI.borderWithColor pink |> Just)

-}
borderWithColor : Color -> Border -> Border
borderWithColor =
    Backend.borderWithColor


{-| Specify one width value to all sides of the border in units.

    emptySquare32x32 =
        UI.empty
            |> UI.withWidth 24
            |> UI.withHeight 24
            |> UI.withBorder (UI.border1uBlack |> UI.borderWithWidth 4 |> Just)

-}
borderWithWidth : Int -> Border -> Border
borderWithWidth =
    Backend.borderWithWidth


{-| Specify the width of X (pair left-right) and Y (pair top-bottom) borders in units.

    emptySquare32x32 =
        UI.empty
            |> UI.withWidth 28
            |> UI.withHeight 24
            |> UI.withBorder
                (UI.border1uBlack
                    |> UI.borderWithWidthXY 2 4
                    |> Just
                )

-}
borderWithWidthXY : Int -> Int -> Border -> Border
borderWithWidthXY =
    Backend.borderWithWidthXY


{-| Specify the width of each side's border.

    emptySquare32x32 =
        UI.empty
            |> UI.withWidth 24
            |> UI.withHeight 24
            |> UI.withBorder
                (UI.border1uBlack
                    |> UI.borderWithWidthEach
                        { top = 6
                        , right = 5
                        , bottom = 2
                        , left = 3
                        }
                    |> Just
                )

-}
borderWithWidthEach : Rect -> Border -> Border
borderWithWidthEach =
    Backend.borderWithWidthEach


{-| Rounds all the corners of said group, including border, content and background (in units).

    emptyCircle =
        UI.empty
            |> UI.withWidth 31
            |> UI.withHeight 31
            |> UI.withBorder (UI.border1uBlack |> UI.borderWithRounding 16 |> Just)

-}
borderWithRounding : Int -> Border -> Border
borderWithRounding =
    Backend.borderWithRounding


{-| Rounds each of the corners of said group, including border, content and background (in units).

    emptyRoudedSquare =
        UI.empty
            |> UI.withWidth 31
            |> UI.withHeight 31
            |> UI.withBorder
                (UI.border1uBlack
                    |> UI.borderWithRoundingEach
                        { topLeft = 8
                        , topRight = 8
                        , bottomRight = 4
                        , bottomLeft = 4
                        }
                    |> Just
                )

-}
borderWithRoundingEach : Corners -> Border -> Border
borderWithRoundingEach =
    Backend.borderWithRoundingEach


{-| Applies outer-shadow to an element.

    square =
        UI.empty
            |> UI.withWidth 32
            |> UI.withHeight 32
            |> UI.withBorder (UI.border1uBlack |> Just)
            |> UI.withOuterShadow
                (shadow1uBlack |> shadowWithColor green |> Just)

-}
withOuterShadow : Maybe Shadow -> Graphics msg -> Graphics msg
withOuterShadow =
    Backend.withOuterShadow


{-| The default shadow, black, 1 unit of length in X (slightly to the right) and Y (slightly to bottom),
1 unit of blur-radius and 1 unit of spread-radius.
-}
shadow1uBlack : Shadow
shadow1uBlack =
    Backend.shadow1uBlack


{-| Change some shadow's color.

    someShadow =
        UI.shadow1uBlack
            |> UI.shadowWithColor cyan

-}
shadowWithColor : Color -> Shadow -> Shadow
shadowWithColor =
    Backend.shadowWithColor


{-| Changes the length in units of some shadow.

  - Negatives X values means it grows to the left, positive X values means it grows to the right.
  - Negatives Y values means it grows to the top, positive Y values means it grows to the bottom.

```
someShadow =
    UI.shadow1uBlack
        |> UI.shadowWithLengthXY 12 12
```

-}
shadowWithLengthXY : Int -> Int -> Shadow -> Shadow
shadowWithLengthXY =
    Backend.shadowWithLengthXY


{-| Change some shadow's blur-radius in units.

    someShadow =
        UI.shadow1uBlack
            |> UI.shadowWithBlurRadius 12

-}
shadowWithBlurRadius : Int -> Shadow -> Shadow
shadowWithBlurRadius =
    Backend.shadowWithBlurRadius


{-| Change some shadow's spread-radius in units.

    someShadow =
        UI.shadow1uBlack
            |> UI.shadowWithBlurRadius 12

-}
shadowWithSpreadRadius : Int -> Shadow -> Shadow
shadowWithSpreadRadius =
    Backend.shadowWithSpreadRadius


{-| Where to align text inside a group.

    spacedRow =
        UI.spanText "Foo Bar"
            |> UI.withWidth 640
            |> UI.withTextAlign UI.textCenter

-}
withTextAlign : TextAlignment -> Graphics msg -> Graphics msg
withTextAlign =
    Backend.withTextAlign


{-| Aligns the text to the left.

**NOTE**: Remember that RTL locales exists.

-}
textLeft : TextAlignment
textLeft =
    Backend.TextLeft


{-| Centers the text relative to its group.
-}
textCenter : TextAlignment
textCenter =
    Backend.TextCenter


{-| Aligns the text to the right.

**NOTE**: Remember that RTL locales exists.

-}
textRight : TextAlignment
textRight =
    Backend.TextRight


{-| Aligns an item relative to the cross-axis of its group.

    alignColumnContentsExample =
        UI.column
            [ pinkSquare
                |> UI.withAlignSelf UI.start
                |> Tuple.pair "aligned-on-left"
            , greenSquare
                |> UI.withAlignSelf UI.center
                |> Tuple.pair "aligned-on-center"
            , blueSquare
                |> UI.withAlignSelf UI.end
                |> Tuple.pair "aligned-on-right"
            ]

    alignRowContentsExample =
        UI.row
            [ pinkSquare
                |> UI.withAlignSelf UI.start
                |> Tuple.pair "aligned-on-top"
            , greenSquare
                |> UI.withAlignSelf UI.center
                |> Tuple.pair "aligned-on-center"
            , blueSquare
                |> UI.withAlignSelf UI.end
                |> Tuple.pair "aligned-on-bottom"
            ]

-}
withAlignSelf : Alignment -> Graphics msg -> Graphics msg
withAlignSelf =
    Backend.withAlignSelf


{-| How to align the items of a group.
In a row and in a stack this affects how they're show horizontally.
In a column this affects how they're show vertically.

    alignRowContentsOnRightExample =
        UI.row
            [ pink32uSquare
            , green32uSquare
            , blue32uSquare
            ]
            |> UI.withWidth 640
            |> UI.withJustifyItems UI.end

-}
withJustifyItems : Alignment -> Graphics msg -> Graphics msg
withJustifyItems =
    Backend.withJustifyItems


{-| Aligns contents on start.

    alignColumnContentsOnStartHorizontally =
        UI.indexedColumn
            [ pinkSquare
                |> UI.withAlignSelf UI.start
            , greenSquare
                |> UI.withAlignSelf UI.start
            ]

    alignColumnContentsOnStartVertically =
        UI.column [ item1, item2, item3 ]
            |> UI.withJustifyItems UI.start

-}
start : Alignment
start =
    Backend.Start


{-| Aligns contents on center.

    alignColumnContentsOnCenterHorizontally =
        UI.indexedColumn
            [ pinkSquare
                |> UI.withAlignSelf UI.center
            , greenSquare
                |> UI.withAlignSelf UI.center
            ]

    alignColumnContentsOnCenterVertically =
        UI.column [ item1, item2, item3 ]
            |> UI.withJustifyItems UI.center

-}
center : Alignment
center =
    Backend.Center


{-| Aligns contents on end.

    alignColumnContentsOnEndHorizontally =
        UI.indexedColumn
            [ pinkSquare
                |> UI.withAlignSelf UI.end
            , greenSquare
                |> UI.withAlignSelf UI.end
            ]

    alignColumnContentsOnEndVertically =
        UI.column [ item1, item2, item3 ]
            |> UI.withJustifyItems UI.end

-}
end : Alignment
end =
    Backend.End


{-| Changes the text's color.

Default text's color is inherited, where's in the root element it's black.

    coolTitle =
        UI.spanText "HELLO"
            |> UI.withFontColor pink

-}
withFontColor : Color -> Graphics msg -> Graphics msg
withFontColor =
    Backend.withFontColor


{-| Changes the text's size, in units.

Default text's color is inherited, where's in the root element it's 16 units.

    coolTitle =
        UI.spanText "HELLO"
            |> UI.withFontSize 24

-}
withFontSize : Int -> Graphics msg -> Graphics msg
withFontSize =
    Backend.withFontSize


{-| Changes the text's weight.

Default font's weight is inherited, where's in the root element it's 400.

    coolTitle =
        UI.spanText "HELLO"
            |> UI.withFontWeight 700

-}
withFontWeight : Int -> Graphics msg -> Graphics msg
withFontWeight =
    Backend.withFontWeight


{-| Changes the text's font family. Tries all the font in the list, stopping in the first one available.
The fallback is used when nothing in the list is available.

Default font family value is inherited, where's in the root element it's [`serif`](#serif).

    coolTitle =
        UI.spanText "HELLO"
            |> UI.withFontFamilies
                [ "Borg Sans Mono"
                , "Fira Code"
                , "JuliaMono"
                , "Fantasque Sans Mono"
                ]
                UI.monospace

-}
withFontFamilies : List String -> FontFallback -> Graphics msg -> Graphics msg
withFontFamilies =
    Backend.withFontFamilies


{-| An always-present serif font for fallback when the desired font-family is not found.

See [`withFontFamilies`](#withFontFamilies) for usage.

-}
serif : FontFallback
serif =
    Backend.Serif


{-| An always-present sans-serif font for fallback when the desired font-family is not found.

See [`withFontFamilies`](#withFontFamilies) for usage.

-}
sansSerif : FontFallback
sansSerif =
    Backend.SansSerif


{-| An always-present monospaced font for fallback when the desired font-family is not found.

See [`withFontFamilies`](#withFontFamilies) for usage.

-}
monospace : FontFallback
monospace =
    Backend.Monospace


{-| Instead of forcing the font's family, inherit it from the parent group.

For forcing a fixed one, or to learn about default behavior, see [`withFontFamilies`](#withFontFamilies).

-}
withInheritFontFamilies : Graphics msg -> Graphics msg
withInheritFontFamilies =
    Backend.withInheritFontFamilies


{-| Instead of forcing the font's color, inherit it from the parent group.

For forcing a fixed one, or to learn about default behavior, see [`withFontColor`](#withFontColor).

-}
withInheritFontColor : Graphics msg -> Graphics msg
withInheritFontColor =
    Backend.withInheritFontColor


{-| Instead of forcing the font's size, inherit it from the parent group.

For forcing a fixed one, or to learn about default behavior, see [`withFontSize`](#withFontSize).

-}
withInheritFontSize : Graphics msg -> Graphics msg
withInheritFontSize =
    Backend.withInheritFontSize


{-| Instead of forcing the font's weight, inherit it from the parent group.

For forcing a fixed one, or to learn about default behavior, see [`withFontWeight`](#withFontWeight).

-}
withInheritFontWeight : Graphics msg -> Graphics msg
withInheritFontWeight =
    Backend.withInheritFontWeight


{-| Listen for click events and dispatches the choosen message.

**Implicit effect**: Changes the cursor to the platform's clickable-pointer, when available.

    button =
        UI.withOnClick Msg.IncrementCounter incrementButton

-}
withOnClick : msg -> Graphics msg -> Graphics msg
withOnClick =
    Backend.withOnClick


{-| Outputs Elm-compatible HTML-structure.

**NOTE**: To be used once in an entire document since it provides a generic spreadsheet.

-}
toElmHtml : ElmHtmlEncoder -> Graphics msg -> List (Html msg)
toElmHtml =
    Html.encode


{-| Initialized the default encoder with the default settings:

  - Node are tagged with `<g></g>`;
  - Root nodes have `class="root"`;
  - [Stacked](#stack) nodes have `class="stack"`;
  - `unit` means CSS' `px`.

-}
elmHtmlInit : ElmHtmlEncoder
elmHtmlInit =
    Html.init
