module Msg exposing ( Msg(..) )
import Model exposing (Angle, Speed, Start)

type Msg = Theta Float
         | MouseDown Start
         | MouseUp