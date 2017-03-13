module Messages exposing (Msg(..))

import Date exposing (Date)
import Navigation
import Model exposing (Transaction)
import RemoteData exposing (WebData)
import Http exposing (..)


type Msg
    = NewUrl String
    | UrlChange Navigation.Location
    | Signout
    | CategoryInput String
    | AmountInput String
    | LoadTransactions
    | LoadedTransactions (Result Http.Error (List Transaction))
    | SaveTransaction
    | SavedTransaction (Result Http.Error Transaction)
