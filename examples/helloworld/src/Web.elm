module Web exposing (main)

import Browser
import Main.Model as Model exposing (Flags, Model)
import Main.Msg exposing (Msg)
import Main.Update as Update
import Main.View as View
import UI.Renderer.Html as UIHtml


main : Program Flags Model Msg
main =
    Browser.document
        { init = Model.init
        , subscriptions = \_ -> Sub.none
        , update = Update.update
        , view = View.view >> (\( title, body ) -> { title = title, body = UIHtml.encode viewEncoder body })
        }


viewEncoder : UIHtml.Encoder
viewEncoder =
    UIHtml.init
