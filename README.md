# UbiqueLambda/elm-with-ui

With-pattern UI toolkit for Elm. Oversimplified by now.

## Snippet

```elm
view =
  UI.indexedRow
    [ UI.spanText "Hello" |> UI.withFontWeight 700
    , UI.spanText "World" |> UI.withFontSize 12
    ]
    |> UI.withPadding 32
```

For a more elaborated example check `examples/helloworld/src/Main/View.elm`.

## Grouping

![Grouping](https://raw.githubusercontent.com/UbiqueLambda/elm-with-ui/main/docs/elm-with-ui-groupings.svg)
