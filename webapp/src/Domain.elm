module Domain exposing (..)

import Routing exposing (..)
import Material
import Navigation exposing (newUrl, Location)


type alias Model =
    { route : Routing.Route
    , mdl : Material.Model
    }


type alias Mdl =
    Material.Model


type Msg
    = NoOp
    | SetRoute Route
    | OnLocationChange Location
    | Mdl (Material.Msg Msg)


initModel : Model
initModel =
    { route = Routing.CatalogRoute
    , mdl = Material.model
    }
