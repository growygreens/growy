module Domain.Cultivar exposing (..)

import List.Extra exposing (groupWhile)
import Phrases exposing (..)


cultivarId : Maybe Cultivar -> Maybe Int
cultivarId mc =
    case mc of
        Nothing ->
            Nothing

        Just c ->
            Just c.id


type alias Url =
    String


type alias CultivarId =
    Int


type CultivationPlan
    = SowInAutumn StartTime
    | PlantInFall StartTime
    | BuyPlant StartTime
    | DirectSow StartTime
    | StartIndoor StartTime
    | Greenhouse StartTime


type alias HardinessZone =
    Int


type alias HardinessZoneRequirement =
    ( HardinessZone, HardinessZone )


type PlantLifeCycle
    = Annual
    | Biennial
    | Perennial
    | UnknownLifeCycle


type SunExposureRequirement
    = FullSun
    | DappledSun
    | PartialShade
    | FullSunToPartialShade
    | PartialShadeToFullShade
    | FullShade
    | UnknownSunExposureRequirement


type alias GerminationTimeDays =
    ( Int, Int )


type alias Week =
    Int


type alias HeightCm =
    ( Int, Int )


type alias StartTime =
    ( Week, Week )


type alias DaysToMaturity =
    ( Int, Int )


type alias PlantType =
    String


type alias PlantSubType =
    String


type alias Cultivar =
    { id : CultivarId
    , name : String
    , description : Maybe String
    , images : List Url
    , lifeCycle : PlantLifeCycle
    , hardinessZone : Maybe HardinessZoneRequirement
    , sunExposureRequirements : SunExposureRequirement
    , cultivationPlans : List CultivationPlan
    , germinationTimeDays : Maybe GerminationTimeDays
    , daysToMaturity : Maybe DaysToMaturity
    , heightCm : Maybe HeightCm
    , plantType : PlantType
    , plantSubType : Maybe PlantSubType
    }


groupBy : (a -> comparable) -> List a -> List (List a)
groupBy fn list =
    groupWhile (\x y -> fn x == fn y) list


groupCultivarsOnType : List Cultivar -> List (List Cultivar)
groupCultivarsOnType cultivars =
    let
        sortedByType =
            List.sortBy (.plantType >> toString) cultivars
    in
        groupBy (.plantType >> toString) sortedByType


translatePlantType : PlantType -> Phrases
translatePlantType plantType =
    Phrases.PlantTypePhrase plantType


translateSunRequirement : SunExposureRequirement -> Phrases
translateSunRequirement sunRequirement =
    case sunRequirement of
        FullSun ->
            Phrases.FullSun

        DappledSun ->
            Phrases.DappledSun

        PartialShade ->
            Phrases.PartialShade

        FullSunToPartialShade ->
            Phrases.FullSunToPartialShade

        PartialShadeToFullShade ->
            Phrases.PartialShadeToFullShade

        FullShade ->
            Phrases.FullShade

        UnknownSunExposureRequirement ->
            Phrases.UnknownSunExposureRequirement


translatePlantLifeCycle : PlantLifeCycle -> Phrases
translatePlantLifeCycle lifeCycle =
    case lifeCycle of
        Annual ->
            Phrases.Annual

        Biennial ->
            Phrases.Biennial

        Perennial ->
            Phrases.Perennial

        UnknownLifeCycle ->
            Phrases.UnknownLifeCycle
