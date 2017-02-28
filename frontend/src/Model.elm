module Model exposing (..)

import Date as Date exposing (Date)
import Routing as Routing
import Environment exposing (..)


type alias Model =
    { route : Routing.Route
    , env : Environment
    , user : Maybe User
    , transactions : List Transaction
    , transFormState : TransactionForm
    }


type alias User =
    { uid : String
    , email : String
    }


type alias Transaction =
    { id : Int
    , date : Maybe Date
    , category : String
    , amount : Float
    }


type alias TransactionForm =
    { amountInput : Sting
    , categoryInput : String
    }


init : Environment -> Routing.Route -> Model
init env route =
    { route = route
    , env = env
    , user = Nothing
    , transactions = []
    , transFormState = TransactionForm "" ""
    }
