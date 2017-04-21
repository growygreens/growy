module Main exposing (..)

import Domain exposing (..)
import Catalog.RequestData exposing (fetchCultivars)
import Material
import Navigation exposing (Location)
import Routing exposing (urlFor, Route(..))
import Update exposing (update)
import ViewRoot exposing (viewRoot)


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location

        model =
            initModel
    in
        { model | route = currentRoute } ! [ Material.init Mdl, fetchCultivars ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch ([ Material.subscriptions Mdl model ])


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , update = update
        , view = viewRoot
        , subscriptions = subscriptions
        }
