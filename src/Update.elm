port module Update exposing (..)

import Date
import Debug
import Messages exposing (..)
import Navigation
import Model exposing (..)
import Routing as Routing
import Commands exposing (..)
import Task


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case Debug.log "message" message of
        LoadTransactions ->
            ( model, fetchTransactions )

        LoadedTransactions (Ok response) ->
            ( { model | transactions = response, state = { error = Nothing } }, Cmd.none )

        LoadedTransactions (Err err) ->
            ( { model | state = { error = (Just ("Could not load transactions (" ++ (toString err) ++ ")")) } }, Cmd.none )

        Signout ->
            ( model, Navigation.newUrl "login" )

        NewUrl url ->
            ( model, Navigation.newUrl url )

        UrlChange location ->
            let
                newRoute =
                    Routing.parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        CategoryInput input ->
            let
                formState =
                    model.transactionForm
            in
                ( { model | transactionForm = { formState | category = input } }, Cmd.none )

        AmountInput input ->
            let
                formState =
                    model.transactionForm
            in
                ( { model | transactionForm = { formState | amount = input } }, Cmd.none )

        SaveTransaction ->
            ( model, Task.attempt SavedTransaction (Date.now |> Task.andThen (\date -> saveTransactionRequest model date)) )

        SavedTransaction (Ok transaction) ->
            ( { model | transactions = transaction :: model.transactions }, Cmd.none )

        SavedTransaction (Err err) ->
            ( { model | state = { error = (Just ("Could not save transaction (" ++ (toString err) ++ ")")) } }, Cmd.none )

        DeleteTransaction id ->
            ( model, deleteTransaction id )

        DeletedTransaction (Ok id) ->
            ( { model | transactions = List.filter (\t -> t.id /= id) model.transactions, state = { error = Nothing } }, Cmd.none )

        DeletedTransaction (Err err) ->
            ( { model | state = { error = (Just ("Could not delete transaction (" ++ (toString err) ++ ")")) } }, Cmd.none )
