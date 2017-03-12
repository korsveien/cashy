port module Update exposing (..)

import Debug
import Messages exposing (..)
import Navigation
import Model exposing (..)
import Routing as Routing
import Task exposing (..)


port signoutUser : () -> Cmd msg


parseAmount : String -> Float
parseAmount amount =
    Result.withDefault 0 (String.toFloat amount)


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

        SaveTransaction ->
            let
                foo =
                    1
            in
                ( model, Cmd.none )

        SavedTransaction ->
            ( model, Cmd.none )
