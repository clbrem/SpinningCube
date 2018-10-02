module Update exposing (..)
import Msg exposing (Msg(..))
import Queue
import Model exposing (Model(..), addAngle, getAngle)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    let angle = getAngle model in
    case msg of 
    Theta dTheta -> (addAngle dTheta model, Cmd.none)
    MouseDown start -> ( Down angle start (Queue.new()) , Cmd.none)
    MouseUp -> 
        case model of 
        Down _ _ queue  -> ( queue |> Queue.average |>  Up angle , Cmd.none )
        alreadyUp -> (alreadyUp, Cmd.none)