module DomainTests exposing (tests)

import Test exposing (..)
import Expect
import Domain exposing (..)
import Domain.Cultivar exposing (..)
import I18n
import Routing


makeTestCultivar : CultivarId -> String -> PlantType -> Maybe PlantSubType -> Cultivar
makeTestCultivar id name plantType plantSubType =
    { id = id
    , name = "Early Nantes"
    , description = Nothing
    , images = []
    , hardinessZone = Just ( 5, 6 )
    , lifeCycle = Biennial
    , sunExposureRequirements = FullSun
    , cultivationPlans = [ DirectSow ( 2, 10 ) ]
    , daysToMaturity = 60
    , germinationTimeDays = ( 10, 30 )
    , height = Just 40
    , plantType = plantType
    , plantSubType = plantSubType
    }


tests : Test
tests =
    describe "Domain Unit Tests"
        [ test "Initially, no selected cultivar" <|
            \() -> Expect.equal initModel.selectedCultivar Nothing
        , test "Initially, catalog route active" <|
            \() -> Expect.equal initModel.route Routing.CatalogRoute
        , test "Initially, language is Swedish" <|
            \() -> Expect.equal initModel.language I18n.SvSe
        , test "Group on type: single cultivar" <|
            \() ->
                let
                    cultivars =
                        [ makeTestCultivar 0 "test0" Carrot (Just <| CarrotSubType NantesCarrot) ]

                    groups =
                        groupCultivarsOnType cultivars
                in
                    Expect.equal groups [ (cultivars) ]
        , test "Group on type: multiple types" <|
            \() ->
                let
                    carrot0 =
                        makeTestCultivar 0 "test0" Carrot (Just <| CarrotSubType NantesCarrot)

                    carrot1 =
                        makeTestCultivar 1 "test1" Carrot (Just <| CarrotSubType ChantenayCarrot)

                    onion2 =
                        makeTestCultivar 2 "test2" Onion (Just <| OnionSubType BulbOnion)

                    tomato3 =
                        makeTestCultivar 3 "test3" Tomato (Just <| TomatoSubType CherryTomato)

                    tomato4 =
                        makeTestCultivar 4 "test4" Tomato (Just <| TomatoSubType DeterminateTomato)

                    cultivars =
                        [ carrot0, carrot1, onion2, tomato3, tomato4 ]

                    groups =
                        groupCultivarsOnType cultivars
                in
                    Expect.equal groups [ [ carrot0, carrot1 ], [ onion2 ], [ tomato3, tomato4 ] ]
        , test "Group on type: mixed order" <|
            \() ->
                let
                    carrot0 =
                        makeTestCultivar 0 "test0" Carrot (Just <| CarrotSubType NantesCarrot)

                    carrot1 =
                        makeTestCultivar 1 "test1" Carrot (Just <| CarrotSubType ChantenayCarrot)

                    onion2 =
                        makeTestCultivar 2 "test2" Onion (Just <| OnionSubType BulbOnion)

                    tomato3 =
                        makeTestCultivar 3 "test3" Tomato (Just <| TomatoSubType CherryTomato)

                    tomato4 =
                        makeTestCultivar 4 "test4" Tomato (Just <| TomatoSubType DeterminateTomato)

                    cultivars =
                        [ carrot0, onion2, tomato3, carrot1, tomato4 ]

                    groups =
                        groupCultivarsOnType cultivars
                in
                    Expect.equal groups [ [ carrot0, carrot1 ], [ onion2 ], [ tomato3, tomato4 ] ]
        , test "Group on type: same type, different subtype" <|
            \() ->
                let
                    carrot0 =
                        makeTestCultivar 0 "test0" Carrot (Just <| CarrotSubType NantesCarrot)

                    carrot1 =
                        makeTestCultivar 1 "test1" Carrot (Just <| CarrotSubType ChantenayCarrot)

                    cultivars =
                        [ carrot0, carrot1 ]

                    groups =
                        groupCultivarsOnType cultivars
                in
                    Expect.equal groups [ [ carrot0, carrot1 ] ]
        ]
