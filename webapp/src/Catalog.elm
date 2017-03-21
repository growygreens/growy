module Catalog exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (style, class)
import Domain exposing (..)
import Catalog.DiffView exposing (..)
import Catalog.ListView exposing (..)


view : Model -> Html Msg
view model =
    div
        -- Top layout is row, and fills up then height of view
        [ style
            [ ( "display", "flex" )
            , ( "flex-direction", "row" )
            , ( "height", "100%" )
            ]
        ]
        [ cultivarListView model
        , maybeSelectedCultivar model
        ]
