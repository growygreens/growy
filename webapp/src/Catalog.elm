module Catalog exposing (..)

import Domain exposing (..)
import Html exposing (Html, div, img, text)
import Html.Attributes exposing (src)
import List
import Material.Card as Card
import Material.Button as Button
import Material.Grid exposing (..)
import Material.Icon as Icon
import Material.List as List
import Material.Options as Options exposing (css)
import Phrases exposing (..)
import Maybe

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


imgUrl : Cultivar -> Url
imgUrl c =
    Maybe.withDefault  "/img/generic-cultivar.png" c.imgUrl

selectedCultivarView : Model -> Cultivar -> Html Msg
selectedCultivarView model c =
    Card.view
        [ css "width" "256px"
        , css "margin" "0"
        ]
        [ Card.title
            [ css "flex-direction" "column" ]
            [
             img [src <| imgUrl c][]
             , Card.head [] [ text c.name ]
            , Card.subhead [] [ text <| translatePlantType model c.plantType ]
            ]
        , Card.menu []
            [ Button.render Mdl
                [ 0, 0 ]
                model.mdl
                [ Button.icon
                , Button.ripple
                , Options.onClick DismissSelectedCultivar
                ]
                [ Icon.i "close" ]
            ]
        , Card.actions []
            [ text <| Maybe.withDefault (tr model Phrases.DescriptionMissing) c.description ]
        ]


emptyNode : Html Msg
emptyNode =
    Html.text ""


view : Model -> Html Msg
view model =
    let
        cultivarList =
            List.ul [] (List.map (itemView model) model.cultivars)

        selectedCultivar =
            case cultivarById model.selectedCultivar model of
                Nothing ->
                    emptyNode

                Just c ->
                    selectedCultivarView model c
    in
        grid []
            [ cell [ size All 6, size Tablet 4, size Phone 2 ]
                [ cultivarList ]
            , cell [ size All 6, size Tablet 4, size Phone 2 ]
                [ selectedCultivar ]
            ]
