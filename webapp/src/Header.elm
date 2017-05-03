module Header exposing (viewHeader)

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Material.Button as Button
import Material.Options as Options exposing (css, cs)
import Domain exposing (Model, Msg(..))
import Routing exposing (Route(..))


headerButton : Model -> Int -> Msg -> String -> Html Msg
headerButton model id msg buttonClass =
    Button.render
        Mdl
        [ id ]
        model.mdl
        [ Options.onClick msg
        , cs "header-button"
        , cs "color-white"
        ]
        [ i [ class buttonClass ] [] ]


logo : Html Msg
logo =
    h4
        [ class "color-white"
        , style
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


viewHeader : Model -> Html Msg
viewHeader model =
    div
        -- Outer header row
        [ class "header-row color-green-2-bg"
        ]
        [ logo
        , span [ style [ ( "flex-grow", "1" ) ] ] []
        , span [ style [ ( "padding", "0 16px 0 0" ) ] ]
            [ headerButton model 0 NoOp "fa fa-search"
            , headerButton model 1 (SetRoute CatalogRoute) "fa fa-table"
            , headerButton model 2 NoOp "fa fa-bookmark"
            , headerButton model 3 (SetRoute ProfileRoute) "fa fa-user-circle"
            ]
        ]
