module Model exposing (..)

import Date as Date exposing (Date)
import Routing as Routing
import Environment exposing (..)
import RemoteData exposing (WebData)


type alias Model =
    { route : Routing.Route
    , env : Environment
    , user : Maybe User
    , transactions : WebData (List Transaction)
    , transFormState : TransactionForm
    }


type alias User =
    { uid : String
    , email : String
    }


type alias Transaction =
    { date : Date
    , category : String
    , amount : Float
    }


type alias TransactionForm =
    { amountInput : String
    , categoryInput : String
    }


init : Environment -> Routing.Route -> Model
init env route =
    { route = route
    , env = env
    , user = Nothing
    , transactions = RemoteData.Loading
    , transFormState = TransactionForm "" ""
    }
