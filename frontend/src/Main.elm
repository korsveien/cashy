port module Main exposing (..)

import Navigation as Navigation
import Model exposing (Model)
import Messages exposing (..)
import Routing as Routing
import Update exposing (..)
import View exposing (..)
import Environment exposing (fromLocation)


main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Navigation.Location -> ( Model, Cmd msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location

        env =
            fromLocation location
    in
        ( Model.init env currentRoute, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
