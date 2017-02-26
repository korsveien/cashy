module Model exposing (..)

import Date as Date exposing (Date)
import Routing as Routing


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
    { amountInput : String
    , categoryInput : String
    }


type alias Model =
    { route : Routing.Route
    , user : Maybe User
    , transactions : List Transaction
    , transFormState : TransactionForm
    }


initialModel : Routing.Route -> Model
initialModel route =
    { route = route
    , user = Nothing
    , transactions = []
    , transFormState = TransactionForm "" ""
    }
