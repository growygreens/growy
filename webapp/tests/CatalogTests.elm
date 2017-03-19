module CatalogTests exposing (tests)

import Test exposing (..)
import TestUtils exposing (..)
import Expect
import Domain exposing (initModel, Model, Msg(..))


tests : Test
tests =
    describe "Catalog Unit Tests"
        [ test "Select cultivar selects it" <|
            \() ->
                let
                    newModel =
                        initModel |> updateModel (SelectCultivar 0)
                in
                    Expect.equal newModel.selectedCultivar (Just 0)
        , test "De-select cultivar deselects it" <|
            \() ->
                let
                    newModel =
                        initModel
                            |> updateModel (SelectCultivar 1)
                            |> updateModel DismissSelectedCultivar
                in
                    Expect.equal newModel.selectedCultivar Nothing
        , test "Select cultivar doesn't pin selection" <|
            \() ->
                let
                    newModel =
                        initModel |> updateModel (SelectCultivar 0)
                in
                    Expect.equal newModel.pinnedSelectedCultivar <| Just False
        , test "Pin selected cultivar pins" <|
            \() ->
                let
                    newModel =
                        initModel
                            |> updateModel (SelectCultivar 1)
                            |> updateModel PinSelectedCultivar
                in
                    Expect.equal newModel.pinnedSelectedCultivar <| Just True
        , test "Pin without selected cultivar does nothing" <|
            \() ->
                let
                    newModel =
                        initModel
                            |> updateModel PinSelectedCultivar
                in
                    Expect.equal newModel.pinnedSelectedCultivar Nothing
        , test "Pin again to unpin" <|
            \() ->
                let
                    newModel =
                        initModel
                            |> updateModel (SelectCultivar 1)
                            |> updateModel PinSelectedCultivar
                            |> updateModel (SelectCultivar 2)
                            |> updateModel PinSelectedCultivar
                in
                    Expect.equal newModel.pinnedSelectedCultivar Nothing
        , test "Pin again to dismiss secondary" <|
            \() ->
                let
                    newModel =
                        initModel
                            |> updateModel (SelectCultivar 1)
                            |> updateModel PinSelectedCultivar
                            |> updateModel (SelectCultivar 2)
                            |> updateModel PinSelectedCultivar
                in
                    Expect.equal newModel.secondarySelectedCultivar Nothing
        , test "Select when pinned, selects second cultivar" <|
            \() ->
                let
                    newModel =
                        initModel
                            |> updateModel (SelectCultivar 1)
                            |> updateModel PinSelectedCultivar
                            |> updateModel (SelectCultivar 2)
                in
                    Expect.equal newModel.secondarySelectedCultivar <| Just 2
        , test "Re-selecting same as pinned does nothing" <|
            \() ->
                let
                    newModel =
                        initModel
                            |> updateModel (SelectCultivar 1)
                            |> updateModel PinSelectedCultivar
                            |> updateModel (SelectCultivar 1)
                in
                    Expect.equal newModel.secondarySelectedCultivar <| Nothing
        , test "De-select cultivar also deselects secondary" <|
            \() ->
                let
                    newModel =
                        initModel
                            |> updateModel (SelectCultivar 1)
                            |> updateModel PinSelectedCultivar
                            |> updateModel (SelectCultivar 2)
                            |> updateModel DismissSelectedCultivar
                in
                    Expect.equal newModel.secondarySelectedCultivar <| Nothing
        ]
