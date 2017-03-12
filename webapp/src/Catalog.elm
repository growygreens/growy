module Catalog exposing (..)

import Html exposing (Html, div, text)
import Material.List as List
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Color as Color


itemView : String -> Html msg
itemView plant =
    List.li
        []
        [ List.content [] [ text plant ] ]


view : Html msg
view =
    let
        plants =
            [ "Foo"
            , "Fubar"
            , "Bar"
            ]
    in
        div []
            [ text "This is the Catalog page"
            , List.ul [] (List.map itemView plants)
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
