module Languages.SvSe exposing (..)

import Phrases exposing (..)


translate : Phrases -> String
translate phrase =
    case phrase of
        Tomato ->
            "Tomat"

        Carrot ->
            "Morot"

        Onion ->
            "Lök"

        DescriptionMissing ->
            "Beskrivning saknas"
