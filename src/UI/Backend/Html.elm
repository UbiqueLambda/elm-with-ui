module UI.Backend.Html exposing (Encoder(..), encode, init)

import Html exposing (Html)
import Html.Attributes as HtmlAttr
import Html.Events as HtmlEvents
import Html.Keyed as Keyed
import UI.Backend.CssHelpers as Css
import UI.Backend.Graphics as Graphics exposing (..)


type Encoder
    = Encoder Config


type alias Config =
    { rootClass : String
    , stackClass : String
    , tag : String
    , units : Css.Units
    }


encode : Encoder -> Graphics msg -> List (Html msg)
encode (Encoder config) =
    implicitGroup >> fromGraphics config True >> addStyleKernel config


init : Encoder
init =
    Encoder
        { rootClass = "root"
        , stackClass = "stack"
        , tag = "g"
        , units = Css.Px
        }


addStyleKernel : Config -> Html msg -> List (Html msg)
addStyleKernel config =
    List.singleton >> (::) (styleKernel config)


and : String -> Maybe String -> List (Html.Attribute msg) -> List (Html.Attribute msg)
and key maybeValue accu =
    case maybeValue of
        Just value ->
            HtmlAttr.attribute key value :: accu

        Nothing ->
            accu


andEvent : (msg -> Html.Attribute msg) -> Maybe msg -> List (Html.Attribute msg) -> List (Html.Attribute msg)
andEvent event maybeValue accu =
    case maybeValue of
        Just value ->
            event value :: accu

        Nothing ->
            accu


andStyle : String -> Maybe String -> List (Html.Attribute msg) -> List (Html.Attribute msg)
andStyle key maybeValue accu =
    case maybeValue of
        Just value ->
            HtmlAttr.style key value :: accu

        Nothing ->
            accu


attributesToHtml : Config -> Bool -> Graphics.Attributes msg -> List (Html.Attribute msg)
attributesToHtml config root (Graphics.Attributes attrs) =
    let
        class_ =
            Nothing
                |> maybeClass root config.rootClass
                |> maybeClass (layout.displayDirection == Just Stacked) config.stackClass

        layout =
            removeDefaults attrs.layout
    in
    []
        |> andStyle "align-self" (Maybe.map Css.align layout.alignSelf)
        |> andStyle "background" (Maybe.map Css.background layout.background)
        |> andStyle "border" (Maybe.map Css.border layout.border)
        |> andStyle "border-radius" (Maybe.map (Css.borderRadius config) layout.border)
        |> andStyle "border-width" (Maybe.map (Css.borderWidth config) layout.border)
        |> andStyle "box-shadow" (Maybe.map (Css.shadow config) layout.outerShadow)
        |> andStyle "display" (Css.display layout)
        |> andStyle "flex-direction" (Maybe.andThen Css.direction layout.displayDirection)
        |> andStyle "color" (Maybe.map (Css.inheritable Css.color) layout.fontColor)
        |> andStyle "font-family" (Maybe.map (Css.inheritable Css.font) layout.fontFamilies)
        |> andStyle "font-size" (Maybe.map (Css.inheritable (Css.units config)) layout.fontSize)
        |> andStyle "font-weight" (Maybe.map (Css.inheritable String.fromInt) layout.fontWeight)
        |> andStyle "height" (Maybe.map (Css.length config) layout.height)
        |> andStyle "justify-content" (Maybe.map Css.align layout.justify)
        |> andStyle "overflow-x" (Maybe.map Css.overflow layout.overflowX)
        |> andStyle "overflow-y" (Maybe.map Css.overflow layout.overflowY)
        |> andStyle "padding" (Maybe.map (Css.unitsRect config) layout.padding)
        |> andStyle "gap" (Maybe.map (Css.units config) layout.spacing)
        |> andStyle "text-align" (Maybe.map Css.textAlign layout.textAlign)
        |> andStyle "width" (Maybe.map (Css.length config) layout.width)
        |> andStyle "cursor" (Maybe.map (always "pointer") attrs.events.onClick)
        |> andEvent HtmlEvents.onClick attrs.events.onClick
        |> and "class" class_


fromGraphics : Config -> Bool -> Graphics msg -> Html msg
fromGraphics config root abstraction =
    case abstraction of
        Atomic value ->
            Html.text value

        IndexedGroup attributes group ->
            Html.node config.tag
                (attributesToHtml config root attributes)
                (List.map (fromGraphics config False) group)

        KeyedGroup attributes group ->
            Keyed.node config.tag
                (attributesToHtml config root attributes)
                (List.map (Tuple.mapSecond (fromGraphics config False)) group)


maybeClass : Bool -> String -> Maybe String -> Maybe String
maybeClass pred className maybeAccu =
    if pred then
        case maybeAccu of
            Just accu ->
                Just <| className ++ " " ++ accu

            Nothing ->
                Just className

    else
        maybeAccu


styleKernel : Config -> Html msg
styleKernel config =
    Html.node "style" [] [ Html.text (Css.kernel config) ]
