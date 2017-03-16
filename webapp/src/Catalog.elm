module Catalog exposing (..)

import Domain exposing (..)
import Html exposing (Html, div, img, text, hr)
import Html.Attributes exposing (src, style)
import Material.Button as Button
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Icon as Icon
import Material.Options as Options exposing (css)
import Maybe
import Phrases exposing (..)


cultivarById : Maybe CultivarId -> Model -> Maybe Cultivar
cultivarById id model =
    List.filter (\x -> Just x.id == model.selectedCultivar) model.cultivars |> List.head


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


selectedCultivarView : Model -> Cultivar -> Html Msg
selectedCultivarView model c =
    div
        [ style
            [ ( "display", "flex" )
            , ( "min-width", "276px" )
            , ( "flex-direction", "column" )
            , ( "justify-content", "flex-start" )
            , ( "padding-right", "8px" )
            , ( "overflow-y", "auto" )
            , ( "overflow-x", "hidden" )
            ]
        ]
        [ div
            []
            [ selectedCultivarCard model c ]
        ]


selectedCultivarCard : Model -> Cultivar -> Html Msg
selectedCultivarCard model c =
    Card.view
        [ css "width" "256px"
        , css "margin" "10px"
        , css "padding" "0"
        , Elevation.e6
        ]
        [ Card.title
            [ css "padding" "0"
            ]
            [ img
                [ style
                    [ ( "width", "256px" )
                    , ( "height", "256px" )
                    ]
                , src <| imgUrl c
                ]
                []
            , Card.head
                [ css "padding-left" "16px"
                , css "padding-top" "16px"
                ]
                [ text c.name ]
            , Card.subhead
                [ css "padding-left" "16px"
                , css "font-style" "italic"
                ]
                [ text <| translatePlantType model c.plantType ]
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
        , css "width" "128px"
        , css "background-color" "#408040"
        , css "margin" "8px"
        , Elevation.transition 250
        , if model.selectedCultivar == Just c.id then
            Elevation.e6
          else
            Elevation.e2
        ]
        [ Card.media
            [ css "background" ("url('" ++ (imgUrl c) ++ "') center / cover")
            , css "height" "64px"
            , css "width" "128px"
            ]
            []
        , Card.title
            [ css "height" "64px"
            , css "padding" "8px"
            ]
            [ Card.head
                [ css "font-size" "14px"
                ]
                [ text c.name ]
            , Card.subhead
                []
                [ text <| translatePlantType model c.plantType ]
            ]
        ]


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
            (List.map (cultivarListItemView model) model.cultivars)
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
