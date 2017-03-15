module Model exposing (..)

import Date as Date exposing (Date)
import Routing as Routing
import Environment exposing (..)


type alias Model =
    { route : Routing.Route
    , auth : Auth
    , env : Environment
    , state : State
    , transactions : List Transaction
    , transactionForm : TransactionForm
    }


type alias State =
    { error : Maybe String
    }


type Auth
    = Checking
    | LoggedIn
    | LoggedOut


type alias Transaction =
    { id : String
    , date : Date
    , category : String
    , amount : Float
    }


type alias LoginForm =
    { email : String
    , password : String
    }


type alias TransactionForm =
    { amount : String
    , category : String
    }


init : Environment -> Routing.Route -> Model
init env route =
    { route = route
    , env = env
    , state = { error = Nothing }
    , auth = LoggedOut
    , transactions = []
    , transactionForm = TransactionForm "" ""
    }
