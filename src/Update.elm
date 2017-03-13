port module Update exposing (..)

import Debug
import Messages exposing (..)
import Navigation
import Model exposing (..)
import Routing as Routing
import Commands exposing (..)


port signoutUser : () -> Cmd msg


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
            ( model, signoutUser () )

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
                    model.transFormState
            in
                ( { model | transFormState = { formState | categoryInput = input } }, Cmd.none )

        AmountInput input ->
            let
                formState =
                    model.transFormState
            in
                ( { model | transFormState = { formState | amountInput = input } }, Cmd.none )

        SaveTransaction ->
            ( model, Cmd.none )

        SavedTransaction (Ok transaction) ->
            ( { model | transactions = transaction :: model.transactions }, Cmd.none )

        SavedTransaction (Err err) ->
            ( { model | state = { error = (Just ("Could not save transaction (" ++ (toString err) ++ ")")) } }, Cmd.none )
