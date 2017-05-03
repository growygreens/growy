module Update exposing (..)

import Domain exposing (Model, Msg(..), cultivarById)
import Domain.Cultivar exposing (Cultivar, cultivarId)
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
            case model.pinnedSelectedCultivar of
                Just True ->
                    if cultivarId model.selectedCultivar == Just id then
                        -- Trying to select same cultivar for both primary and secondary: NOP
                        model ! []
                    else
                        { model | secondarySelectedCultivar = cultivarById (Just id) model } ! []

                _ ->
                    { model
                        | selectedCultivar = cultivarById (Just id) model
                        , pinnedSelectedCultivar = Just False
                    }
                        ! []

        DismissSelectedCultivar ->
            { model
                | selectedCultivar = Nothing
                , pinnedSelectedCultivar = Nothing
                , secondarySelectedCultivar = Nothing
            }
                ! []

        PinSelectedCultivar ->
            case model.pinnedSelectedCultivar of
                Just True ->
                    { model
                        | pinnedSelectedCultivar = Nothing
                        , secondarySelectedCultivar = Nothing
                    }
                        ! []

                _ ->
                    case model.selectedCultivar of
                        Just sel ->
                            { model | pinnedSelectedCultivar = Just True } ! []

                        Nothing ->
                            model ! []

        DismissSecondarySelectedCultivar ->
            model ! []

        OnFetchCultivars response ->
            { model | cultivars = response } ! []
