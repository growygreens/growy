module TestUtils exposing (..)

import Domain exposing (Model, Msg(..))
import Update exposing (update)
import Tuple exposing (first)


updateModel : Msg -> Model -> Model
updateModel msg model =
    first <| (update msg model)
