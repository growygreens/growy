module Catalog exposing (..)

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
import Phrases exposing (..)


type CultivarCardRole
    = Primary
    | Secondary


cultivarById : Maybe CultivarId -> Model -> Maybe Cultivar
cultivarById id model =
    List.filter (\x -> Just x.id == id) model.cultivars |> List.head


imgUrl : Cultivar -> Url
imgUrl c =
    Maybe.withDefault "/img/generic-cultivar.png" c.imgUrl


maybeSelectedCultivar : Model -> Html Msg
maybeSelectedCultivar model =
    case cultivarById model.selectedCultivar model of
        Nothing ->
            emptyNode

        Just c ->
            selectedCultivarView model c


maybeSecondarySelection : Model -> Html Msg
maybeSecondarySelection model =
    case cultivarById model.secondarySelectedCultivar model of
        Nothing ->
            emptyNode

        Just c ->
            selectedCultivarCard model c Secondary


selectionBoxWidth : Model -> String
selectionBoxWidth model =
    case model.secondarySelectedCultivar of
        Just _ ->
            "532px"

        _ ->
            "276px"


selectedCultivarView : Model -> Cultivar -> Html Msg
selectedCultivarView model c =
    div
        [ style
            [ ( "min-width", selectionBoxWidth model )
            ]
        , class "selected-cultivar-box"
        ]
        [ div
            []
            [ div
                [ style
                    [ ( "display", "flex" )
                    , ( "flex-direction", "row" )
                    , ( "flex-wrap", "nowrap" )
                    ]
                ]
                [ maybeSecondarySelection model
                , selectedCultivarCard model c Primary
                ]
            ]
        ]


primaryCardMenu : Model -> Card.Block Msg
primaryCardMenu model =
    Card.menu
        [ css "width" "100%"
        , css "left" "0"
        , css "top" "14px"
        ]
        [ Button.render Mdl
            [ 0, 0 ]
            model.mdl
            [ Button.icon
            , Button.ripple
            , Options.onClick DismissSelectedCultivar
            , Color.background Color.accent
            , Color.text Color.accentContrast
            , css "position" "absolute"
            , css "right" "16px"
            ]
            [ Icon.i "close" ]
        , Button.render Mdl
            [ 0, 0 ]
            model.mdl
            [ Button.icon
            , Button.ripple
            , Options.onClick PinSelectedCultivar
            , Color.background Color.accent
            , Color.text Color.accentContrast
            , css "position" "absolute"
            , css "left" "16px"
            ]
            [ if model.pinnedSelectedCultivar == Just True then
                i [ class "fa fa-lock" ] []
              else
                i [ class "fa fa-unlock" ] []
            ]
        ]


secondaryCardMenu : Model -> Card.Block Msg
secondaryCardMenu model =
    Card.menu [] []


selectedCultivarCard : Model -> Cultivar -> CultivarCardRole -> Html Msg
selectedCultivarCard model c role =
    Card.view
        [ Elevation.e6
        , cs "selected-cultivar-card"
        ]
        [ Card.title
            [ css "padding" "0"
            ]
            [ img
                [ style
                    [ ( "width", "256px" )
                    , ( "height", "158px" )
                    ]
                , src <| imgUrl c
                ]
                []
            , Card.head
                [ css "padding-left" "16px"
                , css "padding-top" "16px"
                , css "flex-direction" "row"
                , css "justify-content" "space-between"
                ]
                [ text c.name ]
            , Card.subhead
                [ css "padding-left" "16px"
                , css "font-style" "italic"
                ]
                [ text <| translatePlantType model c.plantType ]
            ]
        , case role of
            Primary ->
                primaryCardMenu model

            Secondary ->
                secondaryCardMenu model
        , Card.text
            [ css "padding-top" "0px" ]
            [ hr [] []
            , text <| Maybe.withDefault (tr model Phrases.DescriptionMissing) c.description
            ]
        ]


emptyNode : Html Msg
emptyNode =
    Html.text ""


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


allCultivars : Model -> List Cultivar
allCultivars model =
    model.cultivars


plantTypeSpacerView : Model -> PlantType -> Html Msg
plantTypeSpacerView model plantType =
    div
        [ style
            [ ( "width", "100%" )
            , ( "margin", "10px 10px 0 10px" )
            , ( "color", "#606060" )
            ]
        ]
        [ hr
            [ style
                [ ( "margin", "10px 0 2px 0" )
                ]
            ]
            []
        , div
            [ style
                [ ( "font-style", "italic" ) ]
            ]
            [ text <| translatePlantType model plantType ]
        ]


cultivarListItemsView : Model -> List (Html Msg)
cultivarListItemsView model =
    let
        selectedName =
            case cultivarById model.selectedCultivar model of
                Just sel ->
                    toString sel.plantType

                Nothing ->
                    ""

        someCultivars =
            if model.pinnedSelectedCultivar == Just True then
                List.filter
                    (\a -> (toString a.plantType) == selectedName)
                    model.cultivars
            else
                model.cultivars

        groupedByType =
            groupCultivarsOnType someCultivars

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



--            ++


cultivarListView : Model -> Html Msg
cultivarListView model =
    div
        [ style
            [ ( "display", "flex" )
            , ( "flex-direction", "column" )
            , ( "flex-grow", "0" )
            , ( "overflow-y", "auto" )
            ]
        ]
        [ div
            [ style
                [ ( "display", "flex" )
                , ( "flex-direction", "row" )
                , ( "flex-wrap", "wrap" )
                ]
            ]
            (cultivarListItemsView model)
        ]


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
