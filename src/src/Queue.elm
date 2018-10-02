module Queue exposing (..)
import Tuple 

type alias Queue t = (List t,  List t, Int)

new : () -> Queue t  
new () = ([], [], 0)

enqueue : t -> Queue t -> Queue t
enqueue item (l1, l2, n) = 
    (item :: l1, l2 , n+1)

dequeue : Queue t -> (Maybe t, Queue t)
dequeue (l1, l2, n) = 
    case (l1, l2) of
        ([], []) -> (Nothing, ([], [], 0))
        (x :: xs, []) -> dequeue ( [], List.reverse l1, n)
        (l, x :: xs) -> (Just x, (l, xs, n-1))

peekFirst : Queue t -> Maybe t
peekFirst (l1, l2, n) =
    case (l1, l2) of 
        ([], []) -> Nothing        
        (x::xs, _) -> Just x
        ([], l) -> l
                   |> List.reverse
                   |> List.head


length : Queue t -> Int
length (l1, l2, n) = n

trim : Int ->  Queue t -> Queue t
trim n (l1, l2, m) = 
    if m > n then
        (l1, l2, m) 
        |> dequeue
        |> Tuple.second
        |> trim n
    else
        (l1, l2, m)

average : Queue Float -> Float
average (l1, l2, n) =
    case n of 
    0 -> 0.0
    m -> (List.sum l1 + List.sum l2) / (toFloat m)