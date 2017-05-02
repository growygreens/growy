module Catalog.ListItemView exposing (..)

import Domain exposing (..)
import Domain.Cultivar exposing (..)
import Html exposing (Html, div, img, text, hr, i)
import Html.Attributes exposing (src, height, style, width)
import Material.Button as Button
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Icon as Icon
import Material.Options as Options exposing (css, cs)
import Maybe
import ViewHelpers exposing (..)


maybePinnedMarker : Model -> Cultivar -> Html Msg
maybePinnedMarker model c =
    if model.selectedCultivar == Just c.id && model.pinnedSelectedCultivar == Just True then
        pinnedMarker model c
    else
        emptyNode


pinnedMarker : Model -> Cultivar -> Html Msg
pinnedMarker model c =
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


cultivarListItemView : Model -> Cultivar -> Html Msg
cultivarListItemView model c =
    Options.div
        [ Options.onClick (SelectCultivar c.id)
        , Elevation.transition 250
        , itemElevation model c
        , css "display" "flex"
        , css "flex-direction" "row"
        , css "margin" "10px"
        , css "width" "450px"
        , css "border-radius" "2px"
        ]
        [ Options.div
            [ css "min-width" "180px"
            , css "min-height" "180px"
            , css "border-radius" "2px 0 0 2px"
            , css "background" (plantBgCss c)
            ]
            []
        , Options.div
            [ css "margin" "10px" ]
            [ Options.div
                [ css "font-size" "18px"
                , css "font-weight" "400"
                ]
                [ text c.name ]
            , Options.div
                [ css "font-size" "16px"
                , css "color" "#404040"
                ]
                [ text c.plantType ]
            , hr [ style [ ( "margin-top", "4px" ), ( "margin-bottom", "6px" ) ] ] []
            , Options.div
                [ css "font-size" "14px"
                , css "color" "#606060"
                ]
                [ text <| String.slice 0 100 (Maybe.withDefault "asdf" c.description) ]
            ]
        ]


plantBgCss : Cultivar -> String
plantBgCss c =
    "url('" ++ (imgUrl c) ++ "') center / cover"


itemElevation : Model -> Cultivar -> Options.Property a b
itemElevation model c =
    if model.selectedCultivar == Just c.id || model.secondarySelectedCultivar == Just c.id then
        Elevation.e6
    else
        Elevation.e4
