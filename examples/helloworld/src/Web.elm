module Web exposing (main)

import Browser
import Html exposing (Html)
import Json.Encode exposing (Value)
import Main.Model as Model exposing (Flags, Model)
import Main.Msg as Msg exposing (Msg)
import Main.Update as Update
import Main.View as View
import UI
import UI.Backend.Html as UIHtml


main : Program Flags Model Msg
main =
    Browser.document
        { init = Model.init
        , view = View.view >> viewEncode
        , update = Update.update
        , subscriptions = \_ -> Sub.none
        }


viewEncode : ( String, UI.Graphics msg ) -> { title : String, body : List (Html msg) }
viewEncode ( title, body ) =
    { title = title, body = UIHtml.encode viewEncoder body }


viewEncoder : UIHtml.Encoder
viewEncoder =
    UIHtml.init
