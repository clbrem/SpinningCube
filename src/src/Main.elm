module Main exposing ( main )

import View exposing ( view )
import Model exposing ( Model )
import Msg exposing ( Msg )
import Browser
import Update exposing ( update )
import Sub exposing ( sub )


main: Program () Model Msg
main = 
    Browser.element
        { init = Model.init
        , view = view
        , subscriptions = sub
        , update = update
        }

