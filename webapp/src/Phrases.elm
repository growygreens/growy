module Phrases exposing (..)


type
    Phrases
    = DescriptionMissing
      -- SunExposureRequirement
    | FullSun
    | DappledSun
    | PartialShade
    | FullSunToPartialShade
    | PartialShadeToFullShade
    | FullShade
    | UnknownSunExposureRequirement
      -- Cultivar Fields
    | HardinessZone
    | SunRequirements
    | GerminationTimeDays
    | LifeCycle
    | DaysToMaturity
      -- PlantLifecycle
    | Annual
    | Biennial
    | Perennial
    | UnknownLifeCycle
    -- Plant types and groups
    | PlantTypePhrase String
    | PlantSubTypePhrase String
    | PlantGroupPhrase String
    | PlantSubGroupPhrase String
