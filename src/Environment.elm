module Environment exposing (..)

import Navigation exposing (Location)


type Environment
    = Local
    | Test
    | Prod
    | Unknown


fromLocation : Location -> Environment
fromLocation location =
    Local
