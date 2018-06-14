module Model exposing (..)
import Queue exposing (..)

type alias Angle = Float
type alias Speed = Float
type alias Start = Int
type alias Velocity = Float

type  Model = Down Angle Start (Queue Velocity)
            | Up Angle Speed 

friction: Float
friction = 0.001

init: () -> (Model, Cmd msg)
init () = (Up 0 0, Cmd.none)

trimAdd : Float -> Queue Float -> Queue Float
trimAdd x = enqueue x >> trim 10

addAngle : Float -> Model -> Model
addAngle delta model = 
    let 
        del = delta |> round
        dTheta = delta / 100 
        dV = delta / 100
    in
    case model of 
    Down angle start list -> Down ( angle + dTheta ) ( start + del) (trimAdd dV list)
    Up angle speed -> Up ( angle + dTheta ) ( decelerate speed )

decelerate : Float -> Float
decelerate speed =
    if speed > friction then
    speed - friction
    else if speed < -friction then
    speed + friction
    else
    0

getAngle : Model -> Angle
getAngle model =
    case model of
    Down angle start list-> angle
    Up angle speed -> angle

getVelocity : Model -> Maybe Velocity
getVelocity model = 
    case model of
    Down angle start list -> Queue.peekFirst list
    Up angle speed -> Just speed


