module Catalog exposing (..)

import Domain exposing (..)
import Html exposing (Html, div, text)
import List
import Material.Card as Card
import Material.List as List
import Material.Options as Options exposing (css)
import Phrases exposing (..)


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


cultivarById : Maybe CultivarId -> Model -> Maybe Cultivar
cultivarById id model =
    List.filter (\x -> Just x.id == model.selectedCultivar) model.cultivars |> List.head


selectedCultivarView : Model -> Cultivar -> Html Msg
selectedCultivarView model c =
    Card.view
        [ css "width" "256px"
        , css "margin" "0"
        ]
        [ Card.title
            [ css "flex-direction" "column" ]
            [ Card.head [] [ text c.name ]
            , Card.subhead [] [ text <| translatePlantType model c.plantType ]
            ]
        , Card.actions []
            [ text <| Maybe.withDefault (tr model Phrases.DescriptionMissing) c.description ]
        ]


view : Model -> Html Msg
view model =
    let
        cultivarList =
            [ List.ul [] (List.map (itemView model) model.cultivars) ]

        selectedCultivar =
            case cultivarById model.selectedCultivar model of
                Nothing ->
                    []

                Just c ->
                    [ selectedCultivarView model c ]
    in
        div [] (cultivarList ++ selectedCultivar)
