module I18n exposing (..)

import Phrases exposing (..)
import Languages.SvSe exposing (translate)


type alias Translator =
    Phrases -> String


type Language
    = SvSe


translate : Language -> Translator
translate lang =
    case lang of
        SvSe ->
            Languages.SvSe.translate
