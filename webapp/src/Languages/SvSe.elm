module Languages.SvSe exposing (..)

import Phrases exposing (..)


translate : Phrases -> String
translate phrase =
    case phrase of
        -- PlantType
        Tomato ->
            "Tomat"

        Carrot ->
            "Morot"

        Onion ->
            "Lök"

        DescriptionMissing ->
            "Beskrivning saknas"

        -- SunExposureRequirement
        FullSun ->
            "Sol"

        DappledSun ->
            "Fläckvis Sol"

        PartialShade ->
            "Halvskugga"

        FullSunToPartialShade ->
            "Sol till halvskugga"

        PartialShadeToFullShade ->
            "Halvskugga till skugga"

        FullShade ->
            "Sugar"

        UnknownSunExposureRequirement ->
            "?"

        -- Cultivar Fields
        HardinessZone ->
            "Växtzon"

        SunRequirements ->
            "Läge"

        GerminationTimeDays ->
            "Grotid (dagar)"

        LifeCycle ->
            "Årighet"

        DaysToMaturity ->
            "Utvecklingstid (dagar)"

        -- PlantLifecycle
        Annual ->
            "Ettårig"

        Biennial ->
            "Tvåårig"

        Perennial ->
            "Flerårig"

        UnknownLifeCycle ->
            "?"
