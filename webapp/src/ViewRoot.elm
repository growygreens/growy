module ViewRoot exposing (..)

import Catalog exposing (view)
import Domain exposing (Model, Msg(..))
import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Material.Layout as Layout
import Material.Options as Options exposing (css, cs)
import Material.Scheme
import Routing exposing (Route(..))
import Header exposing (viewHeader)


viewBody : Model -> Html Msg
viewBody model =
    case model.route of
        Routing.CatalogRoute ->
            Catalog.view model

        Routing.ProfileRoute ->
            text "this is the profile page place holder"

        Routing.NotFoundRoute ->
            text "404-ish - Not found!"


viewRoot : Model -> Html Msg
viewRoot model =
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader
        ]
        { header = [ viewHeader model ]
        , drawer = []
        , tabs = ( [], [] )
        , main =
            [ div
                [ class "main-box" ]
                [ viewBody model ]
            ]
        }
