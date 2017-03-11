module Nav exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Routing exposing (urlFor, Route(..))


view : Html msg
view =
    nav []
        [ ul []
            [ li [] [ a [ href <| urlFor CatalogRoute ] [ text "Catalog" ] ]
            , li [] [ a [ href <| urlFor ProfileRoute ] [ text "Profile" ] ]
            ]
        ]
