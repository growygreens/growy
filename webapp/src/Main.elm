module Main exposing (..)

import Catalog exposing (..)
import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Material
import Material.Button as Button
import Material.Layout as Layout
import Material.Options as Options exposing (css)
import Material.Scheme
import Navigation exposing (newUrl, Location)
import Routing exposing (..)


type alias Model =
    { route : Routing.Route
    , mdl : Material.Model
    }


type alias Mdl =
    Material.Model


type Msg
    = NoOp
    | SetRoute Route
    | OnLocationChange Location
    | Mdl (Material.Msg Msg)


initModel : Model
initModel =
    { route = Routing.CatalogRoute
    , mdl = Material.model
    }


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location

        model =
            initModel
    in
        { model | route = currentRoute } ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        OnLocationChange location ->
            let
                newRoute =
                    Routing.parseLocation location
            in
                { model | route = newRoute } ! []

        SetRoute route ->
            model ! [ newUrl <| urlFor route ]

        Mdl msg_ ->
            Material.update Mdl msg_ model


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch ([ Material.subscriptions Mdl model ])


viewDrawer : Model -> Html Msg
viewDrawer model =
    div []
        [ Button.render Mdl
            [ 0 ]
            model.mdl
            [ Options.onClick (SetRoute CatalogRoute), css "margin" "0 24px" ]
            [ text "Catalog" ]
        , Button.render Mdl
            [ 1 ]
            model.mdl
            [ Options.onClick (SetRoute ProfileRoute), css "margin" "0 24px" ]
            [ text "Profile" ]
        ]


viewHeader : Model -> Html Msg
viewHeader model =
    div
        [ style
            [ ( "text-align", "center" )
            ]
        ]
        [ h4
            [ style
                [ ( "padding", "12px" )
                , ( "margin", "0px" )
                ]
            ]
            [ text "Growy" ]
        ]


viewBody : Model -> Html Msg
viewBody model =
    case model.route of
        Routing.CatalogRoute ->
            Catalog.view

        Routing.ProfileRoute ->
            text "this is the profile page place holder"

        Routing.NotFoundRoute ->
            text "404-ish - Not found!"


view : Model -> Html Msg
view model =
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader
          --, Layout.fixedDrawer
        ]
        { header = [ viewHeader model ]
        , drawer = [ viewDrawer model ]
        , tabs = ( [], [] )
        , main =
            [ div
                []
                [ viewBody model ]
            ]
        }
        |> Material.Scheme.top


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
