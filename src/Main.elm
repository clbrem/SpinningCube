module Main exposing ( main )

import View exposing ( view )
import Model exposing ( Model )
import Msg exposing ( Msg )
import Html 
import Update exposing ( update )
import Sub exposing ( sub )


main: Program Never Model Msg
main = 
    Html.program 
        { init = Model.init()
        , view = view
        , subscriptions = sub
        , update = update
        }

