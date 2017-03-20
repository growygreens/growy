module ViewRoot exposing (..)

import Catalog exposing (view)
import Domain exposing (Model, Msg(..))
import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Material.Button as Button
import Material.Layout as Layout
import Material.Options as Options exposing (css, cs)
import Material.Scheme
import Routing exposing (Route(..))


viewHeader : Model -> Html Msg
viewHeader model =
    div
        -- Outer header row
        [ style
            [ ( "display", "flex" )
            , ( "flex-direction", "row" )
            , ( "align-items", "center" )
            , ( "justify-content", "space-between" )
            , ( "height", "100%" )
            , ( "min-height", "64px" )
            ]
        ]
        [ h4
            [ style
                [ ( "padding", "0 0 0 22px" )
                , ( "margin", "0px" )
                ]
            ]
            [ i
                [ class "fa fa-leaf fa-flip-horizontal"
                , style [ ( "padding", "0 0 0 16px" ) ]
                ]
                []
            , text "Growy"
            ]
        , span [ style [ ( "flex-grow", "1" ) ] ] []
        , span [ style [ ( "padding", "0 16px 0 0" ) ] ]
            [ Button.render Mdl
                [ 0 ]
                model.mdl
                [ Options.onClick NoOp
                , cs "header-button"
                ]
                [ i [ class "fa fa-search" ] [] ]
            , Button.render Mdl
                [ 1 ]
                model.mdl
                [ Options.onClick (SetRoute CatalogRoute)
                , cs "header-button"
                ]
                [ i [ class "fa fa-table" ] [] ]
            , Button.render Mdl
                [ 2 ]
                model.mdl
                [ Options.onClick NoOp
                , cs "header-button"
                ]
                [ i [ class "fa fa-bookmark" ] [] ]
            , Button.render Mdl
                [ 3 ]
                model.mdl
                [ Options.onClick (SetRoute ProfileRoute)
                , cs "header-button"
                ]
                [ i [ class "fa fa-user-circle" ] [] ]
            ]
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
        , drawer = []
        , tabs = ( [], [] )
        , main =
            [ div
                [ style
                    [ ( "height", "100%" )
                    , ( "overflow-y", "hidden" )
                    ]
                ]
                [ viewBody model ]
            ]
        }
