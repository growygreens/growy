module Main exposing (..)

import Html exposing (..)
import Navigation exposing (Location)
import Nav
import Routing
import Catalog exposing (..)


type alias Model =
    { route : Routing.Route }


type Msg
    = NoOp
    | OnLocationChange Location


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        { route = currentRoute } ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        OnLocationChange location ->
            let
                newRoute =
                    Routing.parseLocation location
            in
                { model | route = newRoute } ! []


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    let
        body =
            case model.route of
                Routing.CatalogRoute ->
                    Catalog.view

                Routing.ProfileRoute ->
                    text "this is the profile page place holder"

                Routing.NotFoundRoute ->
                    text "404-ish - Not found!"
    in
        div []
            [ Nav.view
            , body
            ]


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
