module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)


type alias Model =
    Maybe Location


type Route
    = CatalogRoute
    | ProfileRoute
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map CatalogRoute top
        , map CatalogRoute (s "catalog")
        , map ProfileRoute (s "profile")
        ]


urlFor : Route -> String
urlFor route =
    let
        url =
            case route of
                CatalogRoute ->
                    "catalog"

                ProfileRoute ->
                    "profile"

                NotFoundRoute ->
                    ""
    in
        "#/" ++ url


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
