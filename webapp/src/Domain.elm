module Domain exposing (..)

import Routing exposing (..)
import Material
import RemoteData exposing (WebData)
import Navigation exposing (newUrl, Location)
import Domain.Cultivar exposing (..)
import I18n exposing (Language)


type alias Model =
    { route : Routing.Route
    , language : Language
    , cultivars : WebData (List Cultivar)
    , selectedCultivar : Maybe Cultivar
    , cultivarEditMode : Bool
    , pinnedSelectedCultivar : Maybe Bool
    , secondarySelectedCultivar : Maybe Cultivar
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
    | OnFetchCultivars (WebData (List Cultivar))
    | ToggleCultivarEditMode
    | EditCultivarName String


initModel : Model
initModel =
    { route = Routing.CatalogRoute
    , language = I18n.SvSe
    , cultivars = RemoteData.Loading
    , selectedCultivar = Nothing
    , cultivarEditMode = False
    , pinnedSelectedCultivar = Nothing
    , secondarySelectedCultivar = Nothing
    , mdl = Material.model
    }


cultivarById : Maybe CultivarId -> Model -> Maybe Cultivar
cultivarById id model =
    case model.cultivars of
        RemoteData.Success cultivars ->
            List.filter (\x -> Just x.id == id) cultivars |> List.head
        _ ->
            Nothing
