module Catalog.DiffView exposing (..)

import Domain exposing (..)
import Domain.Cultivar exposing (..)
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
import ViewHelpers exposing (..)


type CultivarCardRole
    = Primary
    | Secondary


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
        [ style [ ( "min-width", selectionBoxWidth model ) ]
        , class "selected-cultivar-box-outer"
        ]
        [ div []
            [ div [ class "selected-cultivar-box-inner" ]
                [ maybeSecondarySelection model
                , selectedCultivarCard model c Primary
                ]
            ]
        ]


pinButton : Model -> Html Msg
pinButton model =
    Button.render Mdl
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


dismissSelectedButton : Model -> Html Msg
dismissSelectedButton model =
    Button.render Mdl
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


primaryCardMenu : Model -> Card.Block Msg
primaryCardMenu model =
    Card.menu [ cs "catalog-sel-card-menu" ]
        [ dismissSelectedButton model
        , pinButton model
        ]


secondaryCardMenu : Model -> Card.Block Msg
secondaryCardMenu model =
    Card.menu [] []


cardMenu : Model -> CultivarCardRole -> Card.Block Msg
cardMenu model role =
    case role of
        Primary ->
            primaryCardMenu model

        Secondary ->
            secondaryCardMenu model


selectedCultivarCard : Model -> Cultivar -> CultivarCardRole -> Html Msg
selectedCultivarCard model c role =
    Card.view
        [ Elevation.e6
        , cs "catalog-sel-card"
        ]
        [ Card.title [ cs "catalog-sel-card-title" ]
            [ img
                [ style
                    [ ( "width", "256px" )
                    , ( "height", "158px" )
                    ]
                , src <| imgUrl c
                ]
                []
            , Card.head [ cs "catalog-sel-card-head" ]
                [ text c.name ]
            , Card.subhead [ cs "catalog-sel-card-subhead" ]
                [ text <| tr model (translatePlantType c.plantType) ]
            ]
        , cardMenu model role
        , Card.text [ cs "catalog-list-item-card-text" ]
            [ hr [] []
            , div [] [ text <| (tr model Phrases.HardinessZone) ++ ": " ++ (maybeTupleToString c.hardinessZone) ]
            , div [] [ text <| (tr model Phrases.SunRequirements) ++ ": " ++ tr model (translateSunRequirement c.sunExposureRequirements) ]
            , div [] [ text <| (tr model Phrases.GerminationTimeDays) ++ ": " ++ (maybeTupleToString c.germinationTimeDays) ]
            , div [] [ text <| (tr model Phrases.LifeCycle) ++ ": " ++ tr model (translatePlantLifeCycle c.lifeCycle) ]
            , div [] [ text <| (tr model Phrases.DaysToMaturity) ++ ": " ++ (toString c.daysToMaturity) ]
            , hr [] []
            , div [] [ text <| Maybe.withDefault (tr model Phrases.DescriptionMissing) c.description ]
            ]
        ]


maybeTupleToString : Maybe ( a, b ) -> String
maybeTupleToString t =
    case t of
        Just ( a, b ) ->
            tupleToString ( a, b )

        Nothing ->
            "?"


tupleToString : ( a, b ) -> String
tupleToString ( a, b ) =
    (a |> toString) ++ " - " ++ (b |> toString)
