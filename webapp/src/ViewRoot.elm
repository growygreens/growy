module ViewRoot exposing (..)

import Catalog exposing (view)
import Domain exposing (Model, Msg(..))
import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Material.Button as Button
import Material.Layout as Layout
import Material.Options as Options exposing (css)
import Material.Scheme
import Routing exposing (Route(..))


viewDrawer : Model -> Html Msg
viewDrawer model =
    div []
        [ Button.render Mdl
            [ 0 ]
            model.mdl
            [ Options.onClick (SetRoute CatalogRoute), css "margin" "0 24px" ]
            [ text "Catalog" ]
        , Button.render Mdl
            [ 1 ]
            model.mdl
            [ Options.onClick (SetRoute ProfileRoute), css "margin" "0 24px" ]
            [ text "Profile" ]
        ]


viewHeader : Model -> Html Msg
viewHeader model =
    div
        [ style
            [ ( "text-align", "center" )
            ]
        ]
        [ h4
            [ style
                [ ( "padding", "12px" )
                , ( "margin", "0px" )
                ]
            ]
            [ text "Growy" ]
        ]


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
        , drawer = [ viewDrawer model ]
        , tabs = ( [], [] )
        , main =
            [ div
                [ style [ ( "height", "100%" ) ] ]
                [ viewBody model ]
            ]
        }
        |> Material.Scheme.top
