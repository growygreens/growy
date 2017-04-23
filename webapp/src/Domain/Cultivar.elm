module Domain.Cultivar exposing (..)

import List.Extra exposing (groupWhile)
import Phrases exposing (..)


type alias Url =
    String


type alias CultivarId =
    Int


type PlantType
    = Carrot
    | Onion
    | Tomato


type TomatoSubType
    = BeefsteakTomato
    | CherryTomato
    | DeterminateTomato
    | PlumTomato


type OnionSubType
    = BulbOnion
    | LeekOnion
    | SpringOnion


type alias CultivationPlans =
    List CultivationPlan


type CultivationPlan
    = SowInAutumn StartTime
    | PlantInFall StartTime
    | BuyPlant StartTime
    | DirectSow StartTime
    | StartIndoor StartTime
    | Greenhouse StartTime


type CarrotSubType
    = ChantenayCarrot
    | DanversCarrot
    | ImperatorCarrot
    | NantesCarrot


type PlantSubType
    = TomatoSubType TomatoSubType
    | OnionSubType OnionSubType
    | CarrotSubType CarrotSubType


type alias HardinessZone =
    Int


type alias HardinessZoneRequirement =
    ( HardinessZone, HardinessZone )


type PlantLifeCycle
    = Annual
    | Biennial
    | Perennial


type SunExposureRequirement
    = FullSun
    | DappledSun
    | PartialShade
    | FullSunToPartialShade
    | PartialShadeToFullShade
    | FullShade


type alias GerminationTimeDays =
    ( Int, Int )


type alias Week =
    Int


type alias HeightCm =
    Int


type alias StartTime =
    ( Week, Week )


type alias DaysToMaturity =
    Int


type alias Cultivar =
    { id : CultivarId
    , name : String
    , description : Maybe String
    , images : List Url
    , lifeCycle : PlantLifeCycle
    , hardinessZone : HardinessZoneRequirement
    , sunExposureRequirements : SunExposureRequirement
    , cultivationPlans : CultivationPlans
    , germinationTimeDays : GerminationTimeDays
    , daysToMaturity : DaysToMaturity
    , height : Maybe HeightCm
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
    case plantType of
        Carrot ->
            Phrases.Carrot

        Onion ->
            Phrases.Onion

        Tomato ->
            Phrases.Tomato


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


translatePlantLifeCycle : PlantLifeCycle -> Phrases
translatePlantLifeCycle lifeCycle =
    case lifeCycle of
        Annual ->
            Phrases.Annual

        Biennial ->
            Phrases.Biennial

        Perennial ->
            Phrases.Perennial
