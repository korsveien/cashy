module Routing exposing (..)

import Navigation as Navigation
import UrlParser as Url exposing (s)


type Route
    = NotFoundRoute
    | HomeRoute
    | TransactionRoute
    | SignupRoute
    | LoginRoute


matchers : Url.Parser (Route -> a) a
matchers =
    Url.oneOf
        [ Url.map HomeRoute Url.top
        , Url.map TransactionRoute (s "transactions")
        , Url.map SignupRoute (s "signup")
        , Url.map LoginRoute (s "login")
        ]


parseLocation : Navigation.Location -> Route
parseLocation location =
    case (Url.parsePath matchers location) of
        Just route ->
            Debug.log "route" route

        Nothing ->
            NotFoundRoute
