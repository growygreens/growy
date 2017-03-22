module Catalog.ListItemView exposing (..)

import Domain exposing (..)
import Html exposing (Html, div, img, text, hr, i)
import Material.Button as Button
import Material.Card as Card
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
    Card.view
        [ Options.onClick (SelectCultivar c.id)
        , cs "catalog-list-item-card"
        , Color.background (Color.color Color.Green Color.S200)
        , Elevation.transition 250
        , itemElevation model c
        ]
        [ Card.menu [ cs "catalog-list-item-card-menu" ]
            [ maybePinnedMarker model c ]
        , Card.media
            [ css "background" <| plantBgCss c
            , cs "catalog-list-item-card-media"
            ]
            []
        , Card.title [ cs "catalog-list-item-card-title" ]
            [ Card.head [ cs "catalog-list-item-card-head" ]
                [ text c.name ]
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
        Elevation.e2
