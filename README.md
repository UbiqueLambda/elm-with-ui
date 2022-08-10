# UbiqueLambda/elm-with-ui

With-pattern UI toolkit for Elm. Oversimplified by now.

Different from the backend, expect this package to have a stable API.


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

![Grouping](https://github.com/UbiqueLambda/elm-with-ui/raw/main/docs/elm-with-ui-groupings.svg)


## Installing

You'll need to install `UbiqueLambda/elm-with-ui`, and install [`UbiqueLambda/elm-with-ui-html`](https://github.com/UbiqueLambda/elm-with-ui-html) for rendering.


## Future area of interest

This is an on-going experiment for having Elm with a very lightweight renderer outside of the browser, in a cross-platform way. That's why the API is oversimplified (e.g: no percentage/portion for length).

I'm also interested in reducing the overhead, so in the future I may use lists instead of records in the backend, and the "children list" replaed with a renderer-targeted type.

Here the concept of our rendering stack:

![Renderig Stack](https://github.com/UbiqueLambda/elm-with-ui/raw/main/docs/elm-with-ui-rendering-stack.svg)
