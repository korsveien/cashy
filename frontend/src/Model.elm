module Model exposing (..)

import Date as Date exposing (Date)
import Routing as Routing
import Transaction


type alias User =
    { uid : String
    , email : String
    }


type alias Model =
    { route : Routing.Route
    , user : Maybe User
    , transactions : Transaction.Model
    }


initialModel : Routing.Route -> Model
initialModel route =
    { route = route
    , user = Nothing
    , transactions = Transaction.Model "" "" []
    }
