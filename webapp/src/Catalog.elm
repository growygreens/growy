module Catalog exposing (..)

import Html exposing (Html, div, text)
import Material.List as List
import Material.Color as Color
import Domain exposing (..)
import Material.Options as Options exposing (css)


itemView : Model -> Cultivar -> Html Msg
itemView model plant =
    List.li
        []
        [ List.content
            [ Options.onClick (SelectCultivar plant.id)
            , if (model.selectedCultivar == Just plant.id) then
                css "color" "red"
              else
                css "color" "black"
            ]
            [ text plant.name ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ List.ul [] (List.map (itemView model) model.cultivars)
        ]
