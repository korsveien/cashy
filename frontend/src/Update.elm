port module Update exposing (..)

import Date exposing (Date)
import Debug
import Messages exposing (..)
import Navigation
import Model exposing (..)
import Task
import Routing as Routing


port signoutUser : () -> Cmd msg


parseAmount : String -> Float
parseAmount amount =
    Result.withDefault 0 (String.toFloat amount)


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

        AddTransaction date ->
            let
                id =
                    List.length model.transactions + 1

                amount =
                    parseAmount model.transFormState.amountInput

                category =
                    model.transFormState.categoryInput
            in
                ( { model
                    | transactions = Transaction id (Just date) category amount :: model.transactions
                    , transFormState = { categoryInput = "", amountInput = "" }
                  }
                , Cmd.none
                )

        AddDate ->
            ( model, Task.perform AddTransaction Date.now )

        DeleteTransaction id ->
            ( { model | transactions = List.filter (\trans -> trans.id /= id) model.transactions }, Cmd.none )

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
