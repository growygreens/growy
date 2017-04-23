module Catalog.RequestData exposing (..)

import Http
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Domain exposing (Msg)
import Domain.Cultivar exposing (..)
import RemoteData
import Dict exposing (Dict)


fetchCultivars : Cmd Msg
fetchCultivars =
    Http.get fetchCultivarsUrl cultivarsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Domain.OnFetchCultivars


fetchCultivarsUrl : String
fetchCultivarsUrl =
    "http://localhost:4000/cultivars"


cultivarsDecoder : Decoder (List Cultivar)
cultivarsDecoder =
    list cultivarDecoder


urlDecoder : Decoder Url
urlDecoder =
    string


lifeCycleDecoder : Decoder PlantLifeCycle
lifeCycleDecoder =
    string
        |> andThen
            (\s ->
                case s of
                    "Annual" ->
                        succeed Annual

                    "Biennial" ->
                        succeed Biennial

                    "Perennial" ->
                        succeed Perennial

                    _ ->
                        fail "cannot decode"
            )


hardinessZoneDecoder : Decoder HardinessZoneRequirement
hardinessZoneDecoder =
    (list int)
        |> andThen rangeDecoder


germinationTimeDecoder : Decoder GerminationTimeDays
germinationTimeDecoder =
    (list int)
        |> andThen rangeDecoder


rangeDecoder : List Int -> Decoder ( Int, Int )
rangeDecoder l =
    case l of
        [ from, to ] ->
            succeed ( from, to )

        _ ->
            fail "cannot decode"


sunExposureRequirementsDecoder : Decoder SunExposureRequirement
sunExposureRequirementsDecoder =
    string
        |> andThen
            (\s ->
                case s of
                    "FullSun" ->
                        succeed FullSun

                    "Dappledsun" ->
                        succeed DappledSun

                    "PartialShade" ->
                        succeed PartialShade

                    "FullSunToPartialShade" ->
                        succeed FullSunToPartialShade

                    "FullShade" ->
                        succeed FullShade

                    _ ->
                        fail "cannot decode"
            )


cultivationPlansDecoder : Decoder (List CultivationPlan)
cultivationPlansDecoder =
    (dict (list int))
        |> andThen
            (\d ->
                d
                    |> Dict.toList
                    |> List.map cultivationPlanDecoder
                    |> List.filterMap identity
                    |> succeed
            )


cultivationPlanDecoder : ( String, List Int ) -> Maybe CultivationPlan
cultivationPlanDecoder kvp =
    case kvp of
        ( "SowInAutumn", [ f, t ] ) ->
            Just <| SowInAutumn ( f, t )

        ( "PlantInFall", [ f, t ] ) ->
            Just <| PlantInFall ( f, t )

        ( "BuyPlant", [ f, t ] ) ->
            Just <| BuyPlant ( f, t )

        ( "DirectSow", [ f, t ] ) ->
            Just <| DirectSow ( f, t )

        ( "StartIndoor", [ f, t ] ) ->
            Just <| StartIndoor ( f, t )

        ( "Greenhouse", [ f, t ] ) ->
            Just <| Greenhouse ( f, t )

        _ ->
            Nothing


plantTypeDecoder : Decoder PlantType
plantTypeDecoder =
    string
        |> andThen
            (\t ->
                case t of
                    "Carrot" ->
                        succeed Carrot

                    "Onion" ->
                        succeed Onion

                    "Tomato" ->
                        succeed Tomato

                    _ ->
                        fail "cannot decode"
            )


plantSubTypeDecoder : Decoder PlantSubType
plantSubTypeDecoder =
    string
        |> andThen
            (\t ->
                case t of
                    -- Tomatoes
                    "BeefsteakTomato" ->
                        succeed <| TomatoSubType BeefsteakTomato

                    "CherryTomato" ->
                        succeed <| TomatoSubType CherryTomato

                    "DeterminateTomato" ->
                        succeed <| TomatoSubType DeterminateTomato

                    "PlumTomato" ->
                        succeed <| TomatoSubType PlumTomato

                    -- Onions
                    "BulbOnion" ->
                        succeed <| OnionSubType BulbOnion

                    "LeekOnion" ->
                        succeed <| OnionSubType LeekOnion

                    "SpringOnion" ->
                        succeed <| OnionSubType SpringOnion

                    -- Carrots
                    "ChantenayCarrot" ->
                        succeed <| CarrotSubType ChantenayCarrot

                    "DanversCarrot" ->
                        succeed <| CarrotSubType DanversCarrot

                    "ImperatorCarrot" ->
                        succeed <| CarrotSubType ImperatorCarrot

                    "NantesCarrot" ->
                        succeed <| CarrotSubType NantesCarrot

                    _ ->
                        fail "cannot decode"
            )


cultivarDecoder : Decoder Cultivar
cultivarDecoder =
    decode Cultivar
        |> required "id" int
        |> required "name" string
        |> optional "description" (nullable string) Nothing
        |> optional "images" (list urlDecoder) []
        |> optional "lifeCycle" lifeCycleDecoder UnknownLifeCycle
        |> optional "hardinessZone" (nullable hardinessZoneDecoder) Nothing
        |> optional "sunExposureRequirements" sunExposureRequirementsDecoder UnknownSunExposureRequirement
        |> optional "cultivationPlans" cultivationPlansDecoder []
        |> optional "germinationTimeDays" (nullable ((list int) |> andThen rangeDecoder)) Nothing
        |> optional "daysToMaturity" (nullable ((list int) |> andThen rangeDecoder)) Nothing
        |> optional "height" (nullable ((list int) |> andThen rangeDecoder)) Nothing
        |> required "plantType" plantTypeDecoder
        |> optional "plantSubType" (nullable plantSubTypeDecoder) Nothing
