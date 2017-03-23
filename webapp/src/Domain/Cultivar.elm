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
    , imgUrl : Maybe Url
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


devCreateMockPlants : List Cultivar
devCreateMockPlants =
    [ { id = 105295136411772
      , name = "Early Nantes"
      , description = Just "Phasellus at dui in ligula mollis ultricies.  Cras placerat accumsan nulla.  Nulla posuere.  "
      , imgUrl = Just "img/carrot-1.png"
      , lifeCycle = Biennial
      , hardinessZone = ( 1, 6 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 20 )
      , cultivationPlans = [ DirectSow ( 14, 25 ), SowInAutumn ( 40, 48 ) ]
      , daysToMaturity = 62
      , height = Nothing
      , plantType = Carrot
      , plantSubType = Just <| CarrotSubType NantesCarrot
      }
    , { id = 225026235523732
      , name = "Amsterdam Forcing"
      , description = Just "Phasellus at dui in ligula mollis ultricies.  Cras placerat accumsan nulla.  Nulla posuere.  "
      , imgUrl = Just "img/carrot-3.png"
      , lifeCycle = Biennial
      , hardinessZone = ( 1, 6 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 20 )
      , cultivationPlans = [ DirectSow ( 14, 25 ), SowInAutumn ( 40, 48 ), Greenhouse ( 9, 25 ) ]
      , daysToMaturity = 55
      , height = Nothing
      , plantType = Carrot
      , plantSubType = Nothing
      }
    , { id = 233444673082889
      , name = "Autumn King"
      , description = Just "Pellentesque condimentum, magna ut suscipit hendrerit, ipsum augue ornare nulla, non luctus diam neque sit amet urna.  Etiam laoreet quam sed arcu.  "
      , imgUrl = Just "img/carrot-2.png"
      , lifeCycle = Biennial
      , hardinessZone = ( 1, 6 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 20 )
      , cultivationPlans = [ DirectSow ( 14, 25 ), SowInAutumn ( 40, 48 ) ]
      , daysToMaturity = 75
      , height = Nothing
      , plantType = Carrot
      , plantSubType = Nothing
      }
    , { id = 989031222489761
      , name = "London Market"
      , description = Just "Aenean in sem ac leo mollis blandit.  Aliquam feugiat tellus ut neque.  Nunc rutrum turpis sed pede.  Nullam libero mauris, consequat quis, varius et, dictum id, arcu.  "
      , imgUrl = Just "img/carrot-3.png"
      , lifeCycle = Biennial
      , hardinessZone = ( 1, 6 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 20 )
      , cultivationPlans = [ DirectSow ( 14, 25 ), SowInAutumn ( 40, 48 ) ]
      , daysToMaturity = 70
      , height = Nothing
      , plantType = Carrot
      , plantSubType = Nothing
      }
    , { id = 429490899973647
      , name = "Oxhella"
      , description = Nothing
      , imgUrl = Just "img/carrot-1.png"
      , lifeCycle = Biennial
      , hardinessZone = ( 1, 6 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 20 )
      , cultivationPlans = [ DirectSow ( 14, 25 ), SowInAutumn ( 40, 48 ) ]
      , daysToMaturity = 75
      , height = Nothing
      , plantType = Carrot
      , plantSubType = Nothing
      }
    , { id = 724189906221913
      , name = "Paris Market"
      , description = Nothing
      , imgUrl = Just "img/carrot-1.png"
      , lifeCycle = Biennial
      , hardinessZone = ( 1, 6 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 20 )
      , cultivationPlans = [ DirectSow ( 14, 25 ), SowInAutumn ( 40, 48 ) ]
      , daysToMaturity = 55
      , height = Nothing
      , plantType = Carrot
      , plantSubType = Nothing
      }
    , { id = 836844003600167
      , name = "Nantes Fancy"
      , description = Nothing
      , imgUrl = Just "img/carrot-2.png"
      , lifeCycle = Biennial
      , hardinessZone = ( 1, 6 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 20 )
      , cultivationPlans = [ DirectSow ( 14, 25 ), SowInAutumn ( 40, 48 ) ]
      , daysToMaturity = 65
      , height = Nothing
      , plantType = Carrot
      , plantSubType = Nothing
      }
    , { id = 163538233683543
      , name = "Atomic Red"
      , description = Nothing
      , imgUrl = Just "img/carrot-1.png"
      , lifeCycle = Biennial
      , hardinessZone = ( 1, 6 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 20 )
      , cultivationPlans = [ DirectSow ( 14, 25 ), SowInAutumn ( 40, 48 ) ]
      , daysToMaturity = 70
      , height = Nothing
      , plantType = Carrot
      , plantSubType = Nothing
      }
    , { id = 753630792795779
      , name = "Yellowstone"
      , description = Nothing
      , imgUrl = Just "img/carrot-2.png"
      , lifeCycle = Biennial
      , hardinessZone = ( 1, 6 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 20 )
      , cultivationPlans = [ DirectSow ( 14, 25 ), SowInAutumn ( 40, 48 ) ]
      , daysToMaturity = 72
      , height = Nothing
      , plantType = Carrot
      , plantSubType = Nothing
      }
    , { id = 615862676016153
      , name = "Flakker 2"
      , description = Nothing
      , imgUrl = Just "img/carrot-3.png"
      , lifeCycle = Biennial
      , hardinessZone = ( 1, 6 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 20 )
      , cultivationPlans = [ DirectSow ( 14, 25 ), SowInAutumn ( 40, 48 ) ]
      , daysToMaturity = 80
      , height = Nothing
      , plantType = Carrot
      , plantSubType = Nothing
      }
    , { id = 641300595439137
      , name = "Sturon"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/onion-1.png"
      , lifeCycle = Biennial
      , hardinessZone = ( 1, 6 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 20 )
      , cultivationPlans = [ StartIndoor ( 10, 16 ), DirectSow ( 10, 20 ) ]
      , daysToMaturity = 100
      , height = Nothing
      , plantType = Onion
      , plantSubType = Just <| OnionSubType BulbOnion
      }
    , { id = 650110521194623
      , name = "Ginsburg Bajosta"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/onion-1.png"
      , lifeCycle = Biennial
      , hardinessZone = ( 1, 6 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 20 )
      , cultivationPlans = [ StartIndoor ( 10, 16 ), DirectSow ( 10, 20 ) ]
      , daysToMaturity = 100
      , height = Nothing
      , plantType = Onion
      , plantSubType = Just <| OnionSubType BulbOnion
      }
    , { id = 35117383168927
      , name = "Giant Stuttgart"
      , description = Nothing
      , imgUrl = Just "img/onion-1.png"
      , lifeCycle = Biennial
      , hardinessZone = ( 1, 6 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 20 )
      , cultivationPlans = [ StartIndoor ( 10, 16 ), DirectSow ( 10, 20 ) ]
      , daysToMaturity = 110
      , height = Nothing
      , plantType = Onion
      , plantSubType = Just <| OnionSubType BulbOnion
      }
    , { id = 765749609404342
      , name = "Ida Gold"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/tomato-1.png"
      , lifeCycle = Annual
      , hardinessZone = ( 1, 3 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 5, 15 )
      , cultivationPlans = [ StartIndoor ( 2, 5 ), BuyPlant ( 10, 20 ) ]
      , daysToMaturity = 62
      , height = Nothing
      , plantType = Tomato
      , plantSubType = Just <| TomatoSubType DeterminateTomato
      }
    , { id = 308345818500133
      , name = "Sub-Arctic Plenty"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/tomato-2.png"
      , lifeCycle = Annual
      , hardinessZone = ( 1, 3 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 5, 15 )
      , cultivationPlans = [ StartIndoor ( 2, 5 ), BuyPlant ( 10, 20 ) ]
      , daysToMaturity = 58
      , height = Nothing
      , plantType = Tomato
      , plantSubType = Just <| TomatoSubType DeterminateTomato
      }
    , { id = 841737527473928
      , name = "Taxi"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/tomato-1.png"
      , lifeCycle = Annual
      , hardinessZone = ( 1, 3 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 5, 15 )
      , cultivationPlans = [ StartIndoor ( 2, 5 ), BuyPlant ( 10, 20 ) ]
      , daysToMaturity = 64
      , height = Nothing
      , plantType = Tomato
      , plantSubType = Just <| TomatoSubType DeterminateTomato
      }
    ]
