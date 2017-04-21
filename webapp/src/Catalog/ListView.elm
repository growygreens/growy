module Catalog.ListView exposing (cultivarListView)

import Domain exposing (..)
import Domain.Cultivar exposing (..)
import Html exposing (Html, div, img, text, hr, i)
import Html.Attributes exposing (src, style, class)
import Maybe
import ViewHelpers exposing (..)
import Catalog.ListItemView exposing (..)
import RemoteData exposing (WebData)

cultivarListView : Model -> Html Msg
cultivarListView model =
    div [ class "catalog-box-outer" ]
        [ div [ class "catalog-box-inner" ]
          (maybeList model)
        ]


maybeList : Model -> List(Html Msg)
maybeList model =
    case model.cultivars of
        RemoteData.NotAsked ->
            [text "DBG NOT ASKED"]

        RemoteData.Loading ->
            [text "Loading..."]

        RemoteData.Success cultivars ->
            (cultivarListItemsView model cultivars)

        RemoteData.Failure error ->
            [text (toString error)]


cultivarListItemsView : Model -> List Cultivar -> List (Html Msg)
cultivarListItemsView model cultivars =
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
                        cultivars
            else
                cultivars

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
            [ text <| tr model (translatePlantType plantType) ]
        ]
