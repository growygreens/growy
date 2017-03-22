module Catalog.ListView exposing (cultivarListView)

import Domain exposing (..)
import Html exposing (Html, div, img, text, hr, i)
import Html.Attributes exposing (src, style, class)
import Material.Elevation as Elevation
import Material.Icon as Icon
import Material.Options as Options exposing (css, cs)
import Maybe
import ViewHelpers exposing (..)
import Catalog.ListItemView exposing (..)


cultivarListView : Model -> Html Msg
cultivarListView model =
    div [ class "catalog-box-outer" ]
        [ div [ class "catalog-box-inner" ]
            (cultivarListItemsView model)
        ]


cultivarListItemsView : Model -> List (Html Msg)
cultivarListItemsView model =
    let
        selectedType =
            case cultivarById model.selectedCultivar model of
                Just sel ->
                    toString sel.plantType

                Nothing ->
                    ""

        filteredCultivars =
            if model.pinnedSelectedCultivar == Just True then
                List.filter
                    (\a -> (toString a.plantType) == selectedType)
                    model.cultivars
            else
                model.cultivars

        groupedByType =
            groupCultivarsOnType filteredCultivars

        typeViewFromGroup =
            \cultivarGroup ->
                case List.head cultivarGroup of
                    Just plant ->
                        plantTypeSpacerView model plant.plantType

                    Nothing ->
                        emptyNode

        processCultivarGroup =
            \cultivarGroup ->
                [ typeViewFromGroup cultivarGroup ]
                    ++ (List.map (cultivarListItemView model) <| cultivarGroup)
    in
        List.concat (List.map processCultivarGroup groupedByType)


plantTypeSpacerView : Model -> PlantType -> Html Msg
plantTypeSpacerView model plantType =
    div
        [ class "catalog-type-spacer" ]
        [ hr [ class "catalog-type-spacer-hr" ]
            []
        , div [ class "catalog-type-spacer-text" ]
            [ text <| translatePlantType model plantType ]
        ]
