module Main.Model exposing (Flags, Model, init)

import Main.Msg exposing (Msg)


type alias Flags =
    {}


type alias Model =
    { square0 : Bool
    , square1 : Bool
    , square2 : Bool
    }


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { square0 = True
      , square1 = True
      , square2 = True
      }
    , Cmd.none
    )
