module Messages exposing (Msg(..))

import Date exposing (Date)
import Navigation
import Model exposing (Transaction)
import RemoteData exposing (WebData)


type Msg
    = NewUrl String
    | UrlChange Navigation.Location
    | LoadTransactions (WebData (List Transaction))
    | Signout
    | CategoryInput String
    | AmountInput String
    | SaveTransaction
    | SavedTransaction
