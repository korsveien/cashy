port module Update exposing (..)

import Debug
import Navigation
import Model exposing (Model, User)
import UrlParser as Url
import Routing as Routing
import Transaction


type Msg
    = NewUrl String
    | UrlChange Navigation.Location
    | Signout
    | TransactionMsg Transaction.Msg


port signoutUser : () -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case Debug.log "message" message of
        Signout ->
            ( model, signoutUser () )

        NewUrl url ->
            ( model, Navigation.newUrl url )

        UrlChange location ->
            let
                newRoute =
                    Routing.parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        TransactionMsg transMsg ->
            let
                ( updatedTransModel, transCmd ) =
                    Transaction.update transMsg model.transactions

                _ =
                    Debug.log "updatedTransModel" updatedTransModel
            in
                ( { model | transactions = updatedTransModel }, Cmd.map TransactionMsg transCmd )