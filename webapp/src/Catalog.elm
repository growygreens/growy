module Catalog exposing (..)

import Html exposing (Html, div, text)
import Material.List as List
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Color as Color
import Domain exposing (..)


itemView : Cultivar -> Html msg
itemView plant =
    List.li
        []
        [ List.content [] [ text plant.name ] ]


view : Model -> Html msg
view model =
    div []
        [ List.ul [] (List.map itemView model.cultivars)
        , Card.view
            [ Elevation.e2 ]
            [ Card.title
                [ Color.background Color.primary
                , Color.text Color.white
                ]
                [ Card.head [] [ text "CardHead" ] ]
            , Card.text [] [ text "Text" ]
            ]
        ]
