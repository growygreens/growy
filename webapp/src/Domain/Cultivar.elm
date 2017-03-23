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
    | FlakkerCarror


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
    [ { id = 0
      , name = "Early Nantes"
      , description = Just "Phasellus at dui in ligula mollis ultricies.  Cras placerat accumsan nulla.  Nulla posuere.  "
      , imgUrl = Just "img/carrot-1.png"
      , lifeCycle = Annual
      , hardinessZone = ( 4, 5 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 30 )
      , cultivationPlans = [ StartIndoor ( 2, 5 ), BuyPlant ( 10, 20 ) ]
      , daysToMaturity = 62
      , height = Just 40
      , plantType = Carrot
      , plantSubType = Just <| CarrotSubType NantesCarrot
      }
    , { id = 1
      , name = "Autumn King"
      , description = Just "Pellentesque condimentum, magna ut suscipit hendrerit, ipsum augue ornare nulla, non luctus diam neque sit amet urna.  Etiam laoreet quam sed arcu.  "
      , imgUrl = Just "img/carrot-2.png"
      , lifeCycle = Annual
      , hardinessZone = ( 4, 5 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 30 )
      , cultivationPlans = [ StartIndoor ( 2, 5 ), BuyPlant ( 10, 20 ) ]
      , daysToMaturity = 62
      , height = Just 40
      , plantType = Carrot
      , plantSubType = Just <| CarrotSubType FlakkerCarror
      }
    , { id = 2
      , name = "London Torg"
      , description = Just "Aenean in sem ac leo mollis blandit.  Aliquam feugiat tellus ut neque.  Nunc rutrum turpis sed pede.  Nullam libero mauris, consequat quis, varius et, dictum id, arcu.  "
      , imgUrl = Just "img/carrot-3.png"
      , lifeCycle = Annual
      , hardinessZone = ( 5, 5 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 30 )
      , cultivationPlans = [ StartIndoor ( 2, 5 ), BuyPlant ( 10, 20 ) ]
      , daysToMaturity = 62
      , height = Just 40
      , plantType = Carrot
      , plantSubType = Just <| CarrotSubType ChantenayCarrot
      }
    , { id = 3
      , name = "Oxhella"
      , description = Nothing
      , imgUrl = Just "img/carrot-1.png"
      , lifeCycle = Annual
      , hardinessZone = ( 5, 5 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 30 )
      , cultivationPlans = [ StartIndoor ( 2, 5 ), BuyPlant ( 10, 20 ) ]
      , daysToMaturity = 62
      , height = Just 40
      , plantType = Carrot
      , plantSubType = Nothing
      }
    , { id = 4
      , name = "Sturon"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/onion-1.png"
      , lifeCycle = Annual
      , hardinessZone = ( 5, 5 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 30 )
      , cultivationPlans = [ StartIndoor ( 2, 5 ), BuyPlant ( 10, 20 ) ]
      , daysToMaturity = 62
      , height = Just 40
      , plantType = Onion
      , plantSubType = Just <| OnionSubType BulbOnion
      }
    , { id = 5
      , name = "Ginsburg Bajosta"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/onion-1.png"
      , lifeCycle = Annual
      , hardinessZone = ( 5, 6 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 30 )
      , cultivationPlans = [ StartIndoor ( 2, 5 ), BuyPlant ( 10, 20 ) ]
      , daysToMaturity = 62
      , height = Just 40
      , plantType = Onion
      , plantSubType = Just <| OnionSubType BulbOnion
      }
    , { id = 6
      , name = "Giant Stuttgart"
      , description = Nothing
      , imgUrl = Just "img/onion-1.png"
      , lifeCycle = Annual
      , hardinessZone = ( 5, 7 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 30 )
      , cultivationPlans = [ StartIndoor ( 2, 5 ), BuyPlant ( 10, 20 ) ]
      , daysToMaturity = 62
      , height = Just 40
      , plantType = Onion
      , plantSubType = Just <| OnionSubType BulbOnion
      }
    , { id = 7
      , name = "Ida Gold"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/tomato-1.png"
      , lifeCycle = Annual
      , hardinessZone = ( 5, 8 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 30 )
      , cultivationPlans = [ StartIndoor ( 2, 5 ), BuyPlant ( 10, 20 ) ]
      , daysToMaturity = 62
      , height = Just 40
      , plantType = Tomato
      , plantSubType = Just <| TomatoSubType DeterminateTomato
      }
    , { id = 8
      , name = "Sub-Arctic Plenty"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/tomato-2.png"
      , lifeCycle = Annual
      , hardinessZone = ( 1, 5 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 30 )
      , cultivationPlans = [ StartIndoor ( 2, 5 ), BuyPlant ( 10, 20 ) ]
      , daysToMaturity = 62
      , height = Just 40
      , plantType = Tomato
      , plantSubType = Just <| TomatoSubType DeterminateTomato
      }
    , { id = 9
      , name = "Taxi"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/tomato-1.png"
      , lifeCycle = Annual
      , hardinessZone = ( 1, 5 )
      , sunExposureRequirements = FullSun
      , germinationTimeDays = ( 10, 30 )
      , cultivationPlans = [ StartIndoor ( 2, 5 ), BuyPlant ( 10, 20 ) ]
      , daysToMaturity = 62
      , height = Just 40
      , plantType = Tomato
      , plantSubType = Just <| TomatoSubType DeterminateTomato
      }
    ]
