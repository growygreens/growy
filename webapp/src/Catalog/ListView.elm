module Catalog.ListView exposing (cultivarListView)

import Domain exposing (..)
import Domain.Cultivar exposing (..)
import Html exposing (Html, div, img, text, hr, i)
import Html.Attributes exposing (src, style, class)
import Maybe
import ViewHelpers exposing (..)
import Phrases exposing (..)
import Catalog.ListItemView exposing (..)
import RemoteData exposing (WebData)
import Material.Spinner as Loading exposing (..)


cultivarListView : Model -> Html Msg
cultivarListView model =
    maybeList model


maybeList : Model -> Html Msg
maybeList model =
    case model.cultivars of
        RemoteData.NotAsked ->
            text "DBG NOT ASKED"

        RemoteData.Loading ->
            div
                [ style
                    [ ( "display", "flex" )
                    , ( "flex-direction", "row" )
                    , ( "flex-grow", "1" )
                    , ( "justify-content", "center" )
                    ]
                ]
                [ div
                    [ style
                        [ ( "display", "flex" )
                        , ( "flex-direction", "column" )
                        , ( "justify-content", "center" )
                        , ( "align-items", "center" )
                        ]
                    ]
                    [ Loading.spinner
                        [ Loading.active True
                        , Loading.singleColor True
                        ]
                    , div
                        [ style
                            [ ( "margin-top", "6px" ) ]
                        ]
                        [ Phrases.LoadingPlants |> (tr model) |> text ]
                    ]
                ]

        RemoteData.Success cultivars ->
            -- DEBUG --
            -- Just pick some smaller number until we have a proper
            -- solution to the overwhelming ammount of data
            div [ class "catalog-box-outer" ]
                [ div [ class "catalog-box-inner" ]
                    (cultivars
                        |> (cultivarListItemsView model)
                        |> (List.take 100)
                    )
                ]

        RemoteData.Failure error ->
            text (toString error)


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
