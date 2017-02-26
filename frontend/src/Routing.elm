module Routing exposing (..)

import UrlParser as Url
import Navigation as Navigation


type Route
    = NotFoundRoute
    | HomeRoute


matchers : Url.Parser (Route -> a) a
matchers =
    Url.oneOf
        [ Url.map HomeRoute Url.top
        ]


parseLocation : Navigation.Location -> Route
parseLocation location =
    case (Url.parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
