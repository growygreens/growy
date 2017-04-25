module Languages.SvSe exposing (..)

import Phrases exposing (..)


translate : Phrases -> String
translate phrase =
    case phrase of
        DescriptionMissing ->
            "Beskrivning saknas"

        LoadingPlants ->
            "Hämtar växtdata..."

        BackendError "NetworkError" ->
            "Kan inte ansluta till servern :("

        BackendError _ ->
            "Ett fel uppstod :("

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

        PlantTypePhrase t ->
            t

        PlantSubTypePhrase t ->
            t

        PlantGroupPhrase t ->
            t

        PlantSubGroupPhrase t ->
            t
