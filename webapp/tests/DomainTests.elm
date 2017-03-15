module DomainTests exposing (tests)

import Test exposing (..)
import Expect
import Domain exposing (initModel, Model, Msg(..))
import I18n
import Routing


tests : Test
tests =
    describe "Domain Unit Tests"
        [ test "Initially, no selected cultivar" <|
            \() -> Expect.equal initModel.selectedCultivar Nothing
        , test "Initially, catalog route active" <|
            \() -> Expect.equal initModel.route Routing.CatalogRoute
        , test "Initially, language is Swedish" <|
            \() -> Expect.equal initModel.language I18n.SvSe
        ]
