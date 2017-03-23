module Phrases exposing (..)


type
    Phrases
    -- PlantType
    = Carrot
    | Onion
    | Tomato
    | DescriptionMissing
      -- SunExposureRequirement
    | FullSun
    | DappledSun
    | PartialShade
    | FullSunToPartialShade
    | PartialShadeToFullShade
    | FullShade
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
