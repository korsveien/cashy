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
    , formData : Form
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


type alias Form =
    { amountInput : String
    , categoryInput : String
    }


init : Environment -> Routing.Route -> Model
init env route =
    { route = route
    , env = env
    , state = { error = Nothing }
    , auth = LoggedIn
    , transactions = []
    , formData = Form "" ""
    }
