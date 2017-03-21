module Catalog.ListView exposing (cultivarListView)

import Domain exposing (..)
import Html exposing (Html, div, img, text, hr, i)
import Html.Attributes exposing (src, style, class)
import Material.Button as Button
import Material.Card as Card
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Icon as Icon
import Material.Options as Options exposing (css, cs)
import Maybe
import ViewHelpers exposing (..)


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


cultivarListItemView : Model -> Cultivar -> Html Msg
cultivarListItemView model c =
    Card.view
        [ Options.onClick (SelectCultivar c.id)
        , css "width" "162px"
        , Color.background (Color.color Color.Green Color.S200)
        , css "margin" "8px"
        , Elevation.transition 250
        , if model.selectedCultivar == Just c.id || model.secondarySelectedCultivar == Just c.id then
            Elevation.e6
          else
            Elevation.e2
        ]
        [ Card.menu
            [ css "width" "100%"
            , css "left" "0"
            , css "top" "14px"
            ]
            [ if model.selectedCultivar == Just c.id && model.pinnedSelectedCultivar == Just True then
                Button.render Mdl
                    [ 0, 0 ]
                    model.mdl
                    [ Button.icon
                    , Button.ripple
                    , Button.disabled
                    , Color.background Color.accent
                    , Color.text Color.accentContrast
                    , css "position" "absolute"
                    , css "right" "16px"
                    ]
                    [ Icon.i "compare" ]
              else
                emptyNode
            ]
        , Card.media
            [ css "background" ("url('" ++ (imgUrl c) ++ "') center / cover")
            , css "height" "100px"
            , css "width" "162px"
            ]
            []
        , Card.title
            [ css "padding" "8px"
            ]
            [ Card.head
                [ css "font-size" "16px"
                ]
                [ text c.name ]
            ]
        ]


plantTypeSpacerView : Model -> PlantType -> Html Msg
plantTypeSpacerView model plantType =
    div
        [ class "catalog-type-spacer" ]
        [ hr [ class "catalog-type-spacer-hr" ]
            []
        , div [ class "catalog-type-spacer-text" ]
            [ text <| translatePlantType model plantType ]
        ]
