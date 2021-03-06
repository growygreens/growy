module RequestDataTests exposing (tests)

import Test exposing (..)
import Expect
import Domain.Cultivar exposing (..)
import Catalog.RequestData exposing (..)
import Json.Decode exposing (decodeString)


sampleJsonCultivar : String
sampleJsonCultivar =
    "{ \"id\": 105295136411772,"
        ++ "\"name\": \"Early Nantes\","
        ++ "\"description\": \"Some description.\","
        ++ "\"images\": [\"img.png\"],"
        ++ "\"lifeCycle\": \"Biennial\","
        ++ "\"hardinessZone\": [1, 6],"
        ++ "\"sunExposureRequirements\": \"FullSun\","
        ++ "\"germinationTimeDays\": [10, 20],"
        ++ "\"cultivationPlans\": {"
        ++ "\"DirectSow\": [14, 25],"
        ++ "\"SowInAutumn\": [40, 48] },"
        ++ "\"daysToMaturity\": [62, 62],"
        ++ "\"height\": [100, 120],"
        ++ "\"plantType\": \"Carrot\","
        ++ "\"plantSubType\": \"NantesCarrot\"}"


sparseSampleJsonCultivar : String
sparseSampleJsonCultivar =
    -- No: description, images, plantSubType,
    -- hardinessZone, sunExposureRequirements, lifeCycle
    -- germinationTimeDays, cultivationPlans, daysToMaturity
    "{ \"id\": 105295136411772,"
        ++ "\"name\": \"Early Nantes\","
        ++ "\"plantType\": \"Carrot\"}"


tests : Test
tests =
    describe "Request Data Unit Tests"
        [ test "Plant Lifecycle Decoder happy path" <|
            \() ->
                let
                    annual =
                        decodeString lifeCycleDecoder "\"Annual\""

                    biennal =
                        decodeString lifeCycleDecoder "\"Biennial\""

                    perennial =
                        decodeString lifeCycleDecoder "\"Perennial\""
                in
                    Expect.equal [ Ok Annual, Ok Biennial, Ok Perennial ] [ annual, biennal, perennial ]
        , test "Plant Lifecycle Decoder error handling" <|
            \() ->
                case decodeString lifeCycleDecoder "\"XXX\"" of
                    Err _ ->
                        Expect.pass

                    _ ->
                        Expect.fail "Should fail to decode"
        , test "Full cultivar decoding" <|
            \() ->
                case decodeString cultivarDecoder sampleJsonCultivar of
                    Ok decodedCultivar ->
                        decodedCultivar
                            |> Expect.all
                                [ \c -> Expect.equal 105295136411772 c.id
                                , \c -> Expect.equal "Early Nantes" c.name
                                , \c -> Expect.equal (Just "Some description.") c.description
                                , \c -> Expect.equal [ "img.png" ] c.images
                                , \c -> Expect.equal Biennial c.lifeCycle
                                , \c -> Expect.equal (Just ( 1, 6 )) c.hardinessZone
                                , \c -> Expect.equal FullSun c.sunExposureRequirements
                                , \c -> Expect.equal (Just ( 10, 20 )) c.germinationTimeDays
                                , \c -> Expect.equal (Just ( 100, 120 )) c.heightCm
                                , \c -> Expect.equal [ DirectSow ( 14, 25 ), SowInAutumn ( 40, 48 ) ] c.cultivationPlans
                                , \c -> Expect.equal (Just ( 62, 62 )) c.daysToMaturity
                                , \c -> Expect.equal "Carrot" c.plantType
                                , \c -> Expect.equal (Just "NantesCarrot") c.plantSubType
                                ]

                    Err err ->
                        Expect.fail err
        , test "Sparse cultivar decoding" <|
            \() ->
                case decodeString cultivarDecoder sparseSampleJsonCultivar of
                    Ok decodedCultivar ->
                        decodedCultivar
                            |> Expect.all
                                [ \c -> Expect.equal 105295136411772 c.id
                                , \c -> Expect.equal "Early Nantes" c.name
                                , \c -> Expect.equal Nothing c.description
                                , \c -> Expect.equal [] c.images
                                , \c -> Expect.equal UnknownLifeCycle c.lifeCycle
                                , \c -> Expect.equal Nothing c.hardinessZone
                                , \c -> Expect.equal UnknownSunExposureRequirement c.sunExposureRequirements
                                , \c -> Expect.equal Nothing c.germinationTimeDays
                                , \c -> Expect.equal [] c.cultivationPlans
                                , \c -> Expect.equal Nothing c.daysToMaturity
                                , \c -> Expect.equal "Carrot" c.plantType
                                , \c -> Expect.equal Nothing c.plantSubType
                                ]

                    Err err ->
                        Expect.fail err
        ]
