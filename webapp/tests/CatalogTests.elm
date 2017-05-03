module CatalogTests exposing (tests)

import Test exposing (..)
import TestUtils exposing (..)
import Expect
import Domain exposing (initModel, Model, Msg(..))
import Domain.Cultivar exposing (..)
import RemoteData exposing (WebData)


makeTestCultivar : CultivarId -> Cultivar
makeTestCultivar id =
    { id = id
    , name = "TestCultivar"
    , description = Nothing
    , images = []
    , hardinessZone = Just ( 5, 6 )
    , lifeCycle = Biennial
    , sunExposureRequirements = FullSun
    , cultivationPlans = [ DirectSow ( 2, 10 ) ]
    , daysToMaturity = Just ( 60, 60 )
    , germinationTimeDays = Just ( 10, 30 )
    , heightCm = Just ( 40, 60 )
    , plantType = "Carrot"
    , plantSubType = Nothing
    }


simpleModel : Model
simpleModel =
    { initModel
        | cultivars =
            RemoteData.Success
                [ makeTestCultivar 0
                , makeTestCultivar 1
                , makeTestCultivar 2
                ]
    }


tests : Test
tests =
    describe "Catalog Unit Tests"
        [ test "Select cultivar selects it" <|
            \() ->
                let
                    newModel =
                        simpleModel |> updateModel (SelectCultivar 0)
                in
                    Expect.equal (newModel.selectedCultivar |> cultivarId) (Just 0)
        , test "De-select cultivar deselects it" <|
            \() ->
                let
                    newModel =
                        simpleModel
                            |> updateModel (SelectCultivar 1)
                            |> updateModel DismissSelectedCultivar
                in
                    Expect.equal newModel.selectedCultivar Nothing
        , test "Select cultivar doesn't pin selection" <|
            \() ->
                let
                    newModel =
                        simpleModel |> updateModel (SelectCultivar 0)
                in
                    Expect.equal newModel.pinnedSelectedCultivar <| Just False
        , test "Pin selected cultivar pins" <|
            \() ->
                let
                    newModel =
                        simpleModel
                            |> updateModel (SelectCultivar 1)
                            |> updateModel PinSelectedCultivar
                in
                    Expect.equal newModel.pinnedSelectedCultivar <| Just True
        , test "Pin without selected cultivar does nothing" <|
            \() ->
                let
                    newModel =
                        simpleModel
                            |> updateModel PinSelectedCultivar
                in
                    Expect.equal newModel.pinnedSelectedCultivar Nothing
        , test "Pin again to unpin" <|
            \() ->
                let
                    newModel =
                        simpleModel
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
                        simpleModel
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
                        simpleModel
                            |> updateModel (SelectCultivar 1)
                            |> updateModel PinSelectedCultivar
                            |> updateModel (SelectCultivar 2)
                in
                    Expect.equal (cultivarId newModel.secondarySelectedCultivar) <| Just 2
        , test "Re-selecting same as pinned does nothing" <|
            \() ->
                let
                    newModel =
                        simpleModel
                            |> updateModel (SelectCultivar 1)
                            |> updateModel PinSelectedCultivar
                            |> updateModel (SelectCultivar 1)
                in
                    Expect.equal newModel.secondarySelectedCultivar <| Nothing
        , test "De-select cultivar also deselects secondary" <|
            \() ->
                let
                    newModel =
                        simpleModel
                            |> updateModel (SelectCultivar 1)
                            |> updateModel PinSelectedCultivar
                            |> updateModel (SelectCultivar 2)
                            |> updateModel DismissSelectedCultivar
                in
                    Expect.equal newModel.secondarySelectedCultivar <| Nothing
        ]
