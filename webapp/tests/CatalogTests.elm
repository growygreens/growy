module CatalogTests exposing (tests)

import Test exposing (..)
import Expect
import Domain exposing (initModel, Model, Msg(..))
import Update exposing (update)


tests : Test
tests =
    describe "Catalog Unit Tests"
        [ test "Select Cultivar" <|
            \() ->
                let
                    oldModel =
                        initModel

                    ( newModel, cmd ) =
                        update (SelectCultivar 0) oldModel
                in
                    Expect.equal newModel.selectedCultivar (Just 0)
        , test "De-select Cultivar" <|
            \() ->
                let
                    oldModel =
                        { initModel | selectedCultivar = Just 1 }

                    ( newModel, cmd ) =
                        update DismissSelectedCultivar oldModel
                in
                    Expect.equal newModel.selectedCultivar Nothing
        ]
