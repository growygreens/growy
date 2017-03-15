module Update exposing (..)

import Domain exposing (Model, Msg(..))
import Material exposing (update)
import Navigation exposing (newUrl)
import Routing exposing (urlFor)


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

        SetRoute route ->
            model ! [ newUrl <| urlFor route ]

        Mdl msg_ ->
            Material.update Mdl msg_ model

        SelectCultivar id ->
            { model | selectedCultivar = Just id } ! []

        DismissSelectedCultivar ->
            { model | selectedCultivar = Nothing } ! []
