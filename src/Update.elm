port module Update exposing (..)

import Debug
import Messages exposing (..)
import Navigation
import Model exposing (..)
import Routing as Routing
import Task exposing (..)
import Date
import Random


port signoutUser : () -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case Debug.log "message" message of
        LoadTransactions response ->
            ( { model | transactions = response }, Cmd.none )

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
