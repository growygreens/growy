module Domain exposing (..)

import Routing exposing (..)
import Material
import Navigation exposing (newUrl, Location)
import Domain.Cultivar exposing (..)
import I18n exposing (Language)


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
