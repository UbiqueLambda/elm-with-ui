module UI.Backend.Graphics exposing
    ( Graphics(..), map
    , Color(..), intRGBA
    , Rect, Corners
    , empty, looseText, spanText
    , singleton, row, column, stack, indexedRow, indexedColumn, indexedStack
    , Direction(..)
    , Attributes(..), PureAttributes, Layout, Extensions, MaybeLayout, Overflow(..), Inheritable(..)
    , Length(..), withWidth, withFitContentsX, withHeight, withFitContentsY, withSpacing
    , withPadding, withPaddingXY, withPaddingEach
    , withScrollingX, withScrollingY, Scroll(..), scrollInsetAlwaysVisible
    , withBackground, Background(..), backgroundColor
    , withBorder, Border(..), border1uBlack, borderWithColor
    , borderWithWidth, borderWithWidthXY, borderWithWidthEach
    , borderWithRounding, borderWithRoundingEach
    , withOuterShadow, Shadow(..), shadow1uBlack, shadowWithColor, shadowWithLengthXY, shadowWithBlurRadius, shadowWithSpreadRadius
    , withTextAlign, TextAlignment(..)
    , withAlignSelf, withJustifyItems, Alignment(..)
    , withFontColor, withFontSize, withFontWeight
    , withFontFamilies, FontFallback(..)
    , withInheritFontFamilies, withInheritFontColor, withInheritFontSize, withInheritFontWeight
    , withOnClick
    , removeDefaults, implicitGroup
    )

{-|

@docs Graphics, map

@docs Color, intRGBA

@docs Rect, Corners

@docs empty, looseText, spanText

@docs singleton, row, column, stack, indexedRow, indexedColumn, indexedStack

@docs Direction

@docs Attributes, PureAttributes, Layout, Extensions, MaybeLayout, Overflow, Inheritable

@docs Length, withWidth, withFitContentsX, withHeight, withFitContentsY, withSpacing

@docs withPadding, withPaddingXY, withPaddingEach

@docs withScrollingX, withScrollingY, Scroll, scrollInsetAlwaysVisible

@docs withBackground, Background, backgroundColor

@docs withBorder, Border, border1uBlack, borderWithColor

@docs borderWithWidth, borderWithWidthXY, borderWithWidthEach

@docs borderWithRounding, borderWithRoundingEach

@docs withOuterShadow, Shadow, shadow1uBlack, shadowWithColor, shadowWithLengthXY, shadowWithBlurRadius, shadowWithSpreadRadius

@docs withTextAlign, TextAlignment

@docs withAlignSelf, withJustifyItems, Alignment

@docs withFontColor, withFontSize, withFontWeight

@docs withFontFamilies, FontFallback

@docs withInheritFontFamilies, withInheritFontColor, withInheritFontSize, withInheritFontWeight

@docs withOnClick

@docs removeDefaults, implicitGroup

-}

import UI.Backend.Helpers exposing (..)


type Graphics msg
    = Atomic String
    | IndexedGroup (Attributes msg) (List (Graphics msg))
    | KeyedGroup (Attributes msg) (List ( String, Graphics msg ))


type Color
    = IntRGBA Int


type alias Rect =
    { top : Int, right : Int, bottom : Int, left : Int }


type alias Corners =
    { topLeft : Int, topRight : Int, bottomRight : Int, bottomLeft : Int }


type Direction
    = Horizontal
    | Vertical
    | Stacked


{-| You are supposed to not let this type escape to the final API
-}
type Attributes msg
    = Attributes (PureAttributes msg)


{-| You are supposed to not let this type escape to the final API
-}
type alias PureAttributes msg =
    { layout : Layout
    , events : Events msg
    , extensions : Extensions
    }


{-| You are supposed to not let this type escape to the final API
-}
type alias Layout =
    { alignSelf : Alignment -- "start" is default
    , background : Maybe Background
    , border : Maybe Border
    , displayDirection : Maybe Direction
    , fontColor : Inheritable Color -- inherit is default, "black" is root's default
    , fontFamilies : Inheritable ( List String, FontFallback ) -- inherit is default, "serif" is root's default
    , fontSize : Inheritable Int -- inherit is default, "16px" is root's default
    , fontWeight : Inheritable Int -- inherit is default, "400" is root's default
    , height : Length -- "fit-content" is default
    , justify : Alignment -- "start" is default
    , outerShadow : Maybe Shadow
    , overflowX : Overflow -- "clip" is default
    , overflowY : Overflow -- "clip" is default
    , padding : Rect -- zero is default
    , spacing : Int -- zero is default
    , textAlign : TextAlignment -- Default is LTR, but you should handle the localization problem yourself.
    , width : Length -- "fit-content" is default
    }


{-| You are supposed to not let this type escape to the final API

This is suppossed to be used for features that may not be supported by all platforms.

-}
type alias Extensions =
    { percentageSizes : Maybe { width : Maybe Float, height : Maybe Float }
    , viewportSizes : Maybe { width : Maybe Float, height : Maybe Float }
    }


{-| You are supposed to not let this type escape to the final API
-}
type alias MaybeLayout =
    {- You can use to cleanup the values that are already the same as default in your API -}
    { alignSelf : Maybe Alignment
    , background : Maybe Background
    , border : Maybe Border
    , displayDirection : Maybe Direction
    , fontColor : Maybe (Inheritable Color)
    , fontFamilies : Maybe (Inheritable ( List String, FontFallback ))
    , fontSize : Maybe (Inheritable Int)
    , fontWeight : Maybe (Inheritable Int)
    , height : Maybe Length
    , justify : Maybe Alignment
    , outerShadow : Maybe Shadow
    , overflowX : Maybe Overflow
    , overflowY : Maybe Overflow
    , padding : Maybe Rect
    , spacing : Maybe Int
    , textAlign : Maybe TextAlignment -- Default depends on LTR and RTL.
    , width : Maybe Length
    }


{-| You are supposed to not let this type escape to the final API
-}
type Overflow
    = Clip
    | Scrolling Scroll


{-| You are supposed to not let this type escape to the final API
-}
type Inheritable a
    = Inherit
    | Own a


{-| "Units" here is defined by the renderer, please, stop mixing a bunch of metrics (px, in, em) in the same surface.
-}
type Length
    = FitContents
    | Units Int


type Scroll
    = Scroll
        { alwaysVisible : Bool -- Even when contents in smaller then container
        , inset : Bool -- Wish they didn't deprecate overlay in HTML
        }


type Background
    = Background
        { color : Color
        }


type Border
    = Border
        { color : Color
        , width : Rect
        , rounding : Corners
        }


type Shadow
    = Shadow
        { color : Color
        , lengthX : Int
        , lengthY : Int
        , blurRadius : Int
        , spreadRadius : Int
        }


type TextAlignment
    = TextLeft
    | TextCenter
    | TextRight


type Alignment
    = Start
    | Center
    | End


type FontFallback
    = SansSerif
    | Serif
    | Monospace


{-| You are supposed to not let this type escape to the final API
-}
type alias Events msg =
    { onClick : Maybe msg
    }


map : (a -> msg) -> Graphics a -> Graphics msg
map mapper graphics =
    let
        mapAttributes (Attributes { layout, events, extensions }) =
            Attributes
                { layout = layout
                , events = { onClick = Maybe.map mapper events.onClick }
                , extensions = extensions
                }

        recursiveMap original =
            case original of
                Atomic atomic ->
                    Atomic atomic

                IndexedGroup attributes list ->
                    IndexedGroup
                        (mapAttributes attributes)
                        (List.map recursiveMap list)

                KeyedGroup attributes list ->
                    KeyedGroup
                        (mapAttributes attributes)
                        (List.map (Tuple.mapSecond recursiveMap) list)
    in
    recursiveMap graphics


{-| Elm's Int is 32 bits, don't fear it, use hexadecimal for colors.

red = intRGBA 0xFF0000FF

-}
intRGBA : Int -> Color
intRGBA int =
    IntRGBA int


empty : Graphics msg
empty =
    looseText ""


looseText : String -> Graphics msg
looseText value =
    Atomic value


spanText : String -> Graphics msg
spanText =
    looseText >> singleton


singleton : Graphics msg -> Graphics msg
singleton v =
    case v of
        Atomic "" ->
            IndexedGroup emptyAttributes []

        _ ->
            IndexedGroup emptyAttributes [ v ]


row : List ( String, Graphics msg ) -> Graphics msg
row =
    KeyedGroup emptyAttributes
        >> withDisplayDirection Horizontal


column : List ( String, Graphics msg ) -> Graphics msg
column =
    row >> withDisplayDirection Vertical


stack : List ( String, Graphics msg ) -> Graphics msg
stack =
    KeyedGroup emptyAttributes
        >> withDisplayDirection Stacked


{-| You're supposed to tell the user to avoid this
-}
indexedRow : List (Graphics msg) -> Graphics msg
indexedRow =
    IndexedGroup emptyAttributes
        >> withDisplayDirection Horizontal


{-| You're supposed to tell the user to avoid this
-}
indexedColumn : List (Graphics msg) -> Graphics msg
indexedColumn =
    indexedRow >> withDisplayDirection Vertical


{-| You're supposed to tell the user to avoid this
-}
indexedStack : List (Graphics msg) -> Graphics msg
indexedStack =
    IndexedGroup emptyAttributes
        >> withDisplayDirection Stacked


withWidth : Int -> Graphics msg -> Graphics msg
withWidth width =
    withLayoutAttribute (\layout -> { layout | width = Units width })


withFitContentsX : Graphics msg -> Graphics msg
withFitContentsX =
    withLayoutAttribute (\layout -> { layout | width = FitContents })


withHeight : Int -> Graphics msg -> Graphics msg
withHeight height =
    withLayoutAttribute (\layout -> { layout | height = Units height })


withFitContentsY : Graphics msg -> Graphics msg
withFitContentsY =
    withLayoutAttribute (\layout -> { layout | height = FitContents })


withSpacing : Int -> Graphics msg -> Graphics msg
withSpacing spacing =
    withLayoutAttribute (\layout -> { layout | spacing = spacing })


withPadding : Int -> Graphics msg -> Graphics msg
withPadding padding =
    withLayoutAttribute (\layout -> { layout | padding = singletonRect padding })


withPaddingXY : Int -> Int -> Graphics msg -> Graphics msg
withPaddingXY x y =
    withLayoutAttribute (\layout -> { layout | padding = { top = y, right = x, bottom = y, left = x } })


withPaddingEach : Rect -> Graphics msg -> Graphics msg
withPaddingEach rect =
    withLayoutAttribute (\layout -> { layout | padding = rect })


withScrollingX : Maybe Scroll -> Graphics msg -> Graphics msg
withScrollingX maybeScroll =
    withLayoutAttribute
        (\layout ->
            { layout
                | overflowX =
                    maybeScroll
                        |> Maybe.map Scrolling
                        |> Maybe.withDefault Clip
            }
        )


withScrollingY : Maybe Scroll -> Graphics msg -> Graphics msg
withScrollingY maybeScroll =
    withLayoutAttribute
        (\layout ->
            { layout
                | overflowY =
                    maybeScroll
                        |> Maybe.map Scrolling
                        |> Maybe.withDefault Clip
            }
        )


scrollInsetAlwaysVisible : Scroll
scrollInsetAlwaysVisible =
    Scroll
        { alwaysVisible = True
        , inset = True
        }


withBackground : Maybe Background -> Graphics msg -> Graphics msg
withBackground maybeBackground =
    withLayoutAttribute (\layout -> { layout | background = maybeBackground })


backgroundColor : Color -> Background
backgroundColor color =
    Background { color = color }


withBorder : Maybe Border -> Graphics msg -> Graphics msg
withBorder maybeBorder =
    withLayoutAttribute (\layout -> { layout | border = maybeBorder })


border1uBlack : Border
border1uBlack =
    Border { color = black, width = singletonRect 1, rounding = singletonCorners 0 }


borderWithColor : Color -> Border -> Border
borderWithColor color (Border border) =
    Border { border | color = color }


borderWithWidth : Int -> Border -> Border
borderWithWidth width (Border border) =
    Border { border | width = singletonRect width }


borderWithWidthXY : Int -> Int -> Border -> Border
borderWithWidthXY x y (Border border) =
    Border { border | width = { top = y, right = x, bottom = y, left = x } }


borderWithWidthEach : Rect -> Border -> Border
borderWithWidthEach widthRect (Border border) =
    Border { border | width = widthRect }


borderWithRounding : Int -> Border -> Border
borderWithRounding rounding (Border border) =
    Border { border | rounding = singletonCorners rounding }


borderWithRoundingEach : Corners -> Border -> Border
borderWithRoundingEach roundingCorners (Border border) =
    Border { border | rounding = roundingCorners }


withOuterShadow : Maybe Shadow -> Graphics msg -> Graphics msg
withOuterShadow maybeShadow =
    withLayoutAttribute (\layout -> { layout | outerShadow = maybeShadow })


{-| 1u of X length, 1u of Y length, 1u blur radius, 1u spread radius, and black
-}
shadow1uBlack : Shadow
shadow1uBlack =
    Shadow
        { color = black
        , lengthX = 1
        , lengthY = 1
        , blurRadius = 1
        , spreadRadius = 1
        }


shadowWithColor : Color -> Shadow -> Shadow
shadowWithColor color (Shadow shadow) =
    Shadow { shadow | color = color }


shadowWithLengthXY : Int -> Int -> Shadow -> Shadow
shadowWithLengthXY x y (Shadow shadow) =
    Shadow { shadow | lengthX = x, lengthY = y }


shadowWithBlurRadius : Int -> Shadow -> Shadow
shadowWithBlurRadius radius (Shadow shadow) =
    Shadow { shadow | blurRadius = radius }


shadowWithSpreadRadius : Int -> Shadow -> Shadow
shadowWithSpreadRadius radius (Shadow shadow) =
    Shadow { shadow | spreadRadius = radius }


withTextAlign : TextAlignment -> Graphics msg -> Graphics msg
withTextAlign alignment =
    withLayoutAttribute (\layout -> { layout | textAlign = alignment })


withAlignSelf : Alignment -> Graphics msg -> Graphics msg
withAlignSelf alignment =
    withLayoutAttribute (\layout -> { layout | alignSelf = alignment })


withJustifyItems : Alignment -> Graphics msg -> Graphics msg
withJustifyItems alignment =
    withLayoutAttribute (\layout -> { layout | justify = alignment })


withFontColor : Color -> Graphics msg -> Graphics msg
withFontColor color =
    withLayoutAttribute (\layout -> { layout | fontColor = Own color })


withFontSize : Int -> Graphics msg -> Graphics msg
withFontSize size =
    withLayoutAttribute (\layout -> { layout | fontSize = Own size })


withFontWeight : Int -> Graphics msg -> Graphics msg
withFontWeight weight =
    withLayoutAttribute (\layout -> { layout | fontWeight = Own weight })


withFontFamilies : List String -> FontFallback -> Graphics msg -> Graphics msg
withFontFamilies families fallback =
    withLayoutAttribute (\layout -> { layout | fontFamilies = Own ( families, fallback ) })


withInheritFontFamilies : Graphics msg -> Graphics msg
withInheritFontFamilies =
    withLayoutAttribute (\layout -> { layout | fontFamilies = Inherit })


withInheritFontColor : Graphics msg -> Graphics msg
withInheritFontColor =
    withLayoutAttribute (\layout -> { layout | fontColor = Inherit })


withInheritFontSize : Graphics msg -> Graphics msg
withInheritFontSize =
    withLayoutAttribute (\layout -> { layout | fontSize = Inherit })


withInheritFontWeight : Graphics msg -> Graphics msg
withInheritFontWeight =
    withLayoutAttribute (\layout -> { layout | fontWeight = Inherit })


withOnClick : msg -> Graphics msg -> Graphics msg
withOnClick onClickMsg =
    withEventAttribute (\events -> { events | onClick = Just onClickMsg })


{-| You are supposed to not let this type escape to the final API
-}
removeDefaults : Layout -> MaybeLayout
removeDefaults original =
    { alignSelf = maybeIfNot Start original.alignSelf
    , background = original.background
    , border = original.border
    , displayDirection = original.displayDirection
    , fontColor = maybeIfNot Inherit original.fontColor
    , fontFamilies = maybeIfNot Inherit original.fontFamilies
    , fontSize = maybeIfNot Inherit original.fontSize
    , fontWeight = maybeIfNot Inherit original.fontWeight
    , height = maybeIfNot FitContents original.height
    , justify = maybeIfNot Start original.justify
    , outerShadow = original.outerShadow
    , overflowX = maybeIfNot Clip original.overflowX
    , overflowY = maybeIfNot Clip original.overflowY
    , padding = maybeIfNot (singletonRect 0) original.padding
    , spacing = maybeIfNot 0 original.spacing
    , textAlign = maybeIfNot TextLeft original.textAlign
    , width = maybeIfNot FitContents original.width
    }


{-| You are supposed to not let this type escape to the final API
-}
implicitGroup : Graphics msg -> Graphics msg
implicitGroup v =
    case v of
        Atomic "" ->
            IndexedGroup emptyAttributes []

        Atomic _ ->
            IndexedGroup emptyAttributes [ v ]

        _ ->
            v


black : Color
black =
    intRGBA 0xFF



-- Internals


emptyAttributes : Attributes msg
emptyAttributes =
    Attributes
        { layout =
            { alignSelf = Start
            , background = Nothing
            , border = Nothing
            , displayDirection = Nothing
            , fontColor = Inherit
            , fontFamilies = Inherit
            , fontSize = Inherit
            , fontWeight = Inherit
            , height = FitContents
            , justify = Start
            , outerShadow = Nothing
            , overflowX = Clip
            , overflowY = Clip
            , padding = singletonRect 0
            , spacing = 0
            , textAlign = TextLeft
            , width = FitContents
            }
        , events =
            { onClick = Nothing }
        , extensions =
            { percentageSizes = Nothing
            , viewportSizes = Nothing
            }
        }


singletonCorners : Int -> Corners
singletonCorners n =
    Corners n n n n


singletonRect : Int -> Rect
singletonRect n =
    Rect n n n n


withAttribute :
    (PureAttributes msg -> PureAttributes msg)
    -> Graphics msg
    -> Graphics msg
withAttribute pureMapper graphics =
    let
        mapper (Attributes attr) =
            Attributes <| pureMapper attr
    in
    case graphics of
        Atomic "" ->
            IndexedGroup (mapper emptyAttributes) []

        Atomic atom ->
            IndexedGroup (mapper emptyAttributes) [ Atomic atom ]

        IndexedGroup attributes group ->
            IndexedGroup (mapper attributes) group

        KeyedGroup attributes group ->
            KeyedGroup (mapper attributes) group


withDisplayDirection : Direction -> Graphics msg -> Graphics msg
withDisplayDirection direction =
    withLayoutAttribute (\layout -> { layout | displayDirection = Just direction })


withEventAttribute : (Events msg -> Events msg) -> Graphics msg -> Graphics msg
withEventAttribute mapper =
    withAttribute (\attr -> { attr | events = mapper attr.events })


withLayoutAttribute : (Layout -> Layout) -> Graphics msg -> Graphics msg
withLayoutAttribute mapper =
    withAttribute (\attr -> { attr | layout = mapper attr.layout })
