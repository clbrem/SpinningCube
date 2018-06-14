module Sub exposing ( .. )
import Model exposing ( Model(..) )
import Msg exposing ( Msg(..) )
import Mouse exposing ( downs, ups, moves, Position)
import AnimationFrame 

rotate : Int -> Position -> Msg
rotate start pos =
    (pos.x - start)
    |> toFloat
    |> Theta 

onDown : Model -> Sub Msg
onDown model = 
    case model of 
        Down angle start list -> rotate start |> moves 
        Up angle speed -> Sub.none 

onUp : Model -> Sub Msg
onUp model =     
    case model of 
    Down angle start list -> Sub.none
    Up angle speed -> 
        case speed of 
        0 -> Sub.none
        x -> (\t -> x * t)
             >> Theta
             |> AnimationFrame.diffs



getX : Position -> Int
getX pos = pos.x



sub : Model -> Sub Msg
sub model =
    [ downs ( getX >> MouseDown)
    , ups ( \x -> MouseUp)
    , onDown model
    , onUp model
    ]
    |> Sub.batch

