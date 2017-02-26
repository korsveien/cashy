module Messages exposing (Msg(..))

import Date exposing (Date)
import Navigation


type Msg
    = NewUrl String
    | UrlChange Navigation.Location
    | Signout
    | AddDate
    | AddTransaction Date
    | DeleteTransaction Int
    | CategoryInput String
    | AmountInput String
