port module Main exposing (..)

import Navigation as Navigation
import Model exposing (Model)
import Messages exposing (..)
import Routing as Routing
import Update exposing (..)
import View exposing (..)
import Environment exposing (fromLocation)
import Commands exposing (fetchTransactions)


main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location

        env =
            fromLocation location
    in
        ( Model.init env currentRoute, fetchTransactions )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
