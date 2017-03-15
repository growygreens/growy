port module TestMain exposing (..)

import AllTests
import Test.Runner.Node exposing (run, TestProgram)
import Json.Encode exposing (Value)


main : TestProgram
main =
    run emit AllTests.all


port emit : ( String, Value ) -> Cmd msg
