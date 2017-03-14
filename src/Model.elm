module Model exposing (..)

import Date as Date exposing (Date)
import Routing as Routing
import Environment exposing (..)


type alias Model =
    { route : Routing.Route
    , env : Environment
    , state : State
    , user : Maybe User
    , transactions : List Transaction
    , formData : Form
    }


type alias State =
    { error : Maybe String
    }


type alias User =
    { uid : String
    , email : String
    }


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
    , user = Nothing
    , transactions = []
    , formData = Form "" ""
    }
