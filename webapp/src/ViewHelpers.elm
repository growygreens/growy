module ViewHelpers exposing (..)

import Maybe
import Domain exposing (..)
import Domain.Cultivar exposing (..)
import Html exposing (Html, div, img, text, hr, i)
import I18n exposing (Language)
import Phrases exposing (..)


tr : Model -> Phrases -> String
tr model phrase =
    I18n.translate model.language phrase


imgUrl : Cultivar -> Url
imgUrl c =
    Maybe.withDefault "/img/generic-cultivar.png" c.imgUrl


emptyNode : Html Msg
emptyNode =
    Html.text ""
