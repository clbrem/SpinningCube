module View exposing ( view )
import Graphics exposing (..)
import WebGL exposing ( entity )
import Model exposing (Model(..))
import Msg exposing (Msg(..))
import Html exposing (Html)

import Html.Attributes exposing (width, height, style)

view : Model -> Html Msg

view model =
    WebGL.toHtml
        [ width 400
        , height 400
        , style [ ( "display", "block" ) ]
        ]
        [ cube model ]


