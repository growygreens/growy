module Catalog exposing (..)

import Domain exposing (..)
import Html exposing (Html, div, img, text, hr)
import Html.Attributes exposing (src, style)
import List
import Material.Card as Card
import Material.Button as Button
import Material.Elevation as Elevation
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
    Maybe.withDefault "/img/generic-cultivar.png" c.imgUrl


selectedCultivarView : Model -> Cultivar -> Html Msg
selectedCultivarView model c =
    Card.view
        [ css "width" "256px"
        , css "margin" "10px"
        , css "padding" "0"
        , Elevation.e2
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
                    div
                        [ style
                            [ ( "background-color", "#808080" )
                            , ( "display", "flex" )
                            , ( "flex-direction", "column" )
                            , ( "justify-content", "flex-start" )
                            ]
                        ]
                        [ div
                            []
                            [ selectedCultivarView model c ]
                        ]
    in
        div
            [ style
                [ ( "border", "1px solid orange" )
                , ( "flex-direction", "row" )
                , ( "display", "flex" )
                , ( "flex-grow", "1" )
                , ( "height", "100%" )
                ]
            ]
            [ div
                [ style
                    [ ( "background-color", "#80ffff" )
                    , ( "display", "flex" )
                    , ( "flex-direction", "column" )
                    , ( "flex-grow", "1" )
                    ]
                ]
                [ cultivarList ]
            , selectedCultivar
            ]
