module Sub exposing ( .. )
import Model exposing ( Model(..) )
import Msg exposing ( Msg(..) )
import Tuple 
import Browser.Events exposing ( onMouseDown, onMouseUp, onMouseMove, onAnimationFrameDelta)
import Json.Decode as Decode exposing (Decoder, int)
import Json.Decode.Pipeline exposing (required)


position : Decoder (Int, Int)
position =
    Decode.succeed Tuple.pair
    |> required "pageX" int
    |> required "pageY" int
    

rotate : Int -> Decoder Msg
rotate start =
    position
    |> Decode.map (
        Tuple.first 
        >> (\x -> x - start)
        >> toFloat
        >> Theta
    )
    

onDown : Model -> Sub Msg
onDown model = 
    case model of 
        Down angle start list -> rotate start |> onMouseMove
        Up angle speed -> Sub.none 

onUp : Model -> Sub Msg
onUp model =     
    case model of 
    Down angle start list -> Sub.none
    Up angle speed -> 
        if abs(speed) < 0.0001 then
            Sub.none
        else
            (\t -> speed * t)
             >> Theta
             |> onAnimationFrameDelta
        



sub : Model -> Sub Msg
sub model =
    [ onMouseDown ( position |> Decode.map (Tuple.first >> MouseDown))
    , onMouseUp ( Decode.succeed () |> Decode.map (\x -> MouseUp))
    , onDown model
    , onUp model
    ]
    |> Sub.batch

