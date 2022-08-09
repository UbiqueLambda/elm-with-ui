module Main.Update exposing (update)

import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleSquare0 previous ->
            ( { model | square0 = not previous }, Cmd.none )

        ToggleSquare1 previous ->
            ( { model | square1 = not previous }, Cmd.none )

        ToggleSquare2 previous ->
            ( { model | square2 = not previous }, Cmd.none )
