module Domain exposing (..)

import Routing exposing (..)
import Material
import Navigation exposing (newUrl, Location)
import I18n exposing (Language)
import Phrases exposing (..)
import List.Extra exposing (groupWhile)


type alias CultivarId =
    Int


type alias Url =
    String


type alias CarrotData =
    {}


type alias OnionData =
    {}


type alias TomatoData =
    {}


type PlantType
    = Carrot CarrotData
    | Onion OnionData
    | Tomato TomatoData


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
    = SowInAutumn
    | PlanInFall
    | BuyPlant
    | DirectSow
    | StartIndoor
    | Greenhouse


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


type PlantLifeCycle
    = Annual
    | Biennial
    | Perennial


type SunExposureRequirement
    = FullSun
    | DappledSun
    | PartialShade
    | FullShade


type alias Cultivar =
    { id : CultivarId
    , name : String
    , description : Maybe String
    , imgUrl : Maybe Url
    , lifeCycle : PlantLifeCycle
    , hardinessZone : HardinessZone
    , sunExposureRequirements : SunExposureRequirement
    , cultivationPlans : CultivationPlans
    , plantType : PlantType
    , plantSubType : Maybe PlantSubType
    }


type alias Model =
    { route : Routing.Route
    , language : Language
    , cultivars : List Cultivar
    , selectedCultivar : Maybe CultivarId
    , pinnedSelectedCultivar : Maybe Bool
    , secondarySelectedCultivar : Maybe CultivarId
    , mdl : Material.Model
    }


type alias Mdl =
    Material.Model


type Msg
    = NoOp
    | SetRoute Route
    | OnLocationChange Location
    | Mdl (Material.Msg Msg)
    | SelectCultivar CultivarId
    | DismissSelectedCultivar
    | PinSelectedCultivar
    | DismissSecondarySelectedCultivar


initModel : Model
initModel =
    { route = Routing.CatalogRoute
    , language = I18n.SvSe
    , cultivars = devCreateMockPlants
    , selectedCultivar = Nothing
    , pinnedSelectedCultivar = Nothing
    , secondarySelectedCultivar = Nothing
    , mdl = Material.model
    }


cultivarById : Maybe CultivarId -> Model -> Maybe Cultivar
cultivarById id model =
    List.filter (\x -> Just x.id == id) model.cultivars |> List.head


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


tr : Model -> Phrases -> String
tr model phrase =
    I18n.translate model.language phrase


translatePlantType : Model -> PlantType -> String
translatePlantType model plantType =
    case plantType of
        Carrot _ ->
            tr model Phrases.Carrot

        Onion _ ->
            tr model Phrases.Onion

        Tomato _ ->
            tr model Phrases.Tomato


devCreateMockPlants : List Cultivar
devCreateMockPlants =
    [ { id = 0
      , name = "Early Nantes"
      , description = Just "Phasellus at dui in ligula mollis ultricies.  Cras placerat accumsan nulla.  Nulla posuere.  "
      , imgUrl = Just "img/carrot-1.png"
      , lifeCycle = Annual
      , hardinessZone = 5
      , sunExposureRequirements = FullSun
      , cultivationPlans = [ StartIndoor, BuyPlant ]
      , plantType = Carrot ({})
      , plantSubType = Just <| CarrotSubType NantesCarrot
      }
    , { id = 1
      , name = "Autumn King"
      , description = Just "Pellentesque condimentum, magna ut suscipit hendrerit, ipsum augue ornare nulla, non luctus diam neque sit amet urna.  Etiam laoreet quam sed arcu.  "
      , imgUrl = Just "img/carrot-2.png"
      , lifeCycle = Annual
      , hardinessZone = 5
      , sunExposureRequirements = FullSun
      , cultivationPlans = [ StartIndoor, BuyPlant ]
      , plantType = Carrot {}
      , plantSubType = Just <| CarrotSubType FlakkerCarror
      }
    , { id = 2
      , name = "London Torg"
      , description = Just "Aenean in sem ac leo mollis blandit.  Aliquam feugiat tellus ut neque.  Nunc rutrum turpis sed pede.  Nullam libero mauris, consequat quis, varius et, dictum id, arcu.  "
      , imgUrl = Just "img/carrot-3.png"
      , lifeCycle = Annual
      , hardinessZone = 5
      , sunExposureRequirements = FullSun
      , cultivationPlans = [ StartIndoor, BuyPlant ]
      , plantType = Carrot {}
      , plantSubType = Just <| CarrotSubType ChantenayCarrot
      }
    , { id = 3
      , name = "Oxhella"
      , description = Nothing
      , imgUrl = Just "img/carrot-1.png"
      , lifeCycle = Annual
      , hardinessZone = 5
      , sunExposureRequirements = FullSun
      , cultivationPlans = [ DirectSow ]
      , plantType = Carrot {}
      , plantSubType = Nothing
      }
    , { id = 4
      , name = "Sturon"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/onion-1.png"
      , lifeCycle = Annual
      , hardinessZone = 5
      , sunExposureRequirements = FullSun
      , cultivationPlans = [ DirectSow ]
      , plantType = Onion {}
      , plantSubType = Just <| OnionSubType BulbOnion
      }
    , { id = 5
      , name = "Ginsburg Bajosta"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/onion-1.png"
      , lifeCycle = Annual
      , hardinessZone = 5
      , sunExposureRequirements = FullSun
      , cultivationPlans = [ DirectSow ]
      , plantType = Onion {}
      , plantSubType = Just <| OnionSubType BulbOnion
      }
    , { id = 6
      , name = "Giant Stuttgart"
      , description = Nothing
      , imgUrl = Just "img/onion-1.png"
      , lifeCycle = Annual
      , hardinessZone = 5
      , sunExposureRequirements = FullSun
      , cultivationPlans = [ DirectSow ]
      , plantType = Onion {}
      , plantSubType = Just <| OnionSubType BulbOnion
      }
    , { id = 7
      , name = "Ida Gold"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/tomato-1.png"
      , lifeCycle = Annual
      , hardinessZone = 5
      , sunExposureRequirements = FullSun
      , cultivationPlans = [ StartIndoor, BuyPlant ]
      , plantType = Tomato {}
      , plantSubType = Just <| TomatoSubType DeterminateTomato
      }
    , { id = 8
      , name = "Sub-Arctic Plenty"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/tomato-2.png"
      , lifeCycle = Annual
      , hardinessZone = 5
      , sunExposureRequirements = FullSun
      , cultivationPlans = [ StartIndoor, BuyPlant ]
      , plantType = Tomato {}
      , plantSubType = Just <| TomatoSubType DeterminateTomato
      }
    , { id = 9
      , name = "Taxi"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/tomato-1.png"
      , lifeCycle = Annual
      , hardinessZone = 5
      , sunExposureRequirements = FullSun
      , cultivationPlans = [ StartIndoor, BuyPlant ]
      , plantType = Tomato {}
      , plantSubType = Just <| TomatoSubType DeterminateTomato
      }
    ]
