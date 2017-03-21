module ViewHelpers exposing (..)

import Maybe
import Domain exposing (..)
import Html exposing (Html, div, img, text, hr, i)


imgUrl : Cultivar -> Url
imgUrl c =
    Maybe.withDefault "/img/generic-cultivar.png" c.imgUrl


emptyNode : Html Msg
emptyNode =
    Html.text ""
