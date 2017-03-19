module Domain exposing (..)

import Routing exposing (..)
import Material
import Navigation exposing (newUrl, Location)
import I18n exposing (Language)
import Phrases exposing (..)


type alias CultivarId =
    Int


type alias Url =
    String


type PlantType
    = Carrot (Maybe CarrotSubType)
    | Onion (Maybe OnionSubType)
    | Tomato (Maybe TomatoSubType)


type TomatoSubType
    = BeefsteakTomato
    | CherryTomato
    | DeterminateTomato
    | PlumTomato


type OnionSubType
    = BulbOnion
    | LeekOnion
    | SpringOnion


type CarrotSubType
    = ChantenayCarrot
    | DanversCarrot
    | ImperatorCarrot
    | NantesCarrot
    | FlakkerCarror


type alias Cultivar =
    { id : CultivarId
    , name : String
    , description : Maybe String
    , imgUrl : Maybe Url
    , plantType : PlantType
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


tr : Model -> Phrases -> String
tr model phrase =
    I18n.translate model.language phrase


translatePlantType : Model -> PlantType -> String
translatePlantType model plantType =
    case plantType of
        Carrot subType ->
            tr model Phrases.Carrot

        Onion subType ->
            tr model Phrases.Onion

        Tomato subType ->
            tr model Phrases.Tomato


devCreateMockPlants : List Cultivar
devCreateMockPlants =
    [ { id = 0
      , name = "Early Nantes"
      , description = Just "Phasellus at dui in ligula mollis ultricies.  Cras placerat accumsan nulla.  Nulla posuere.  "
      , imgUrl = Just "img/carrot-1.png"
      , plantType = Carrot <| Just NantesCarrot
      }
    , { id = 1
      , name = "Autumn King"
      , description = Just "Pellentesque condimentum, magna ut suscipit hendrerit, ipsum augue ornare nulla, non luctus diam neque sit amet urna.  Etiam laoreet quam sed arcu.  "
      , imgUrl = Just "img/carrot-2.png"
      , plantType = Carrot <| Just FlakkerCarror
      }
    , { id = 2
      , name = "London Torg"
      , description = Just "Aenean in sem ac leo mollis blandit.  Aliquam feugiat tellus ut neque.  Nunc rutrum turpis sed pede.  Nullam libero mauris, consequat quis, varius et, dictum id, arcu.  "
      , imgUrl = Just "img/carrot-3.png"
      , plantType = Carrot <| Just ChantenayCarrot
      }
    , { id = 3
      , name = "Oxhella"
      , description = Nothing
      , imgUrl = Just "img/carrot-1.png"
      , plantType = Carrot Nothing
      }
    , { id = 4
      , name = "Sturon"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/onion-1.png"
      , plantType = Onion <| Just BulbOnion
      }
    , { id = 5
      , name = "Rijnsburger Bajosta"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/onion-1.png"
      , plantType = Onion <| Just BulbOnion
      }
    , { id = 6
      , name = "Giant Stuttgart"
      , description = Nothing
      , imgUrl = Just "img/onion-1.png"
      , plantType = Onion <| Just BulbOnion
      }
    , { id = 7
      , name = "Ida Gold"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/tomato-1.png"
      , plantType = Tomato <| Just DeterminateTomato
      }
    , { id = 8
      , name = "Sub-Arctic Plenty"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/tomato-2.png"
      , plantType = Tomato <| Just DeterminateTomato
      }
    , { id = 9
      , name = "Taxi"
      , description = Just "Etiam vel neque nec dui dignissim bibendum.  "
      , imgUrl = Just "img/tomato-1.png"
      , plantType = Tomato <| Just DeterminateTomato
      }
    ]
