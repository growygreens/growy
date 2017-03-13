module Tests exposing (..)

import Test exposing (..)
import Expect
import String


all : Test
all =
    describe "Sample Test Suite"
        [ describe "Unit test examples"
            [ test "Addition" <|
                \() ->
                    Expect.equal (3 + 7) 10
            , test "String.left" <|
                \() ->
                    Expect.equal "a" (String.left 1 "abcdefg")
            -- , test "This test should fail - you should remove it" <|
            --     \() ->
            --         Expect.fail "Failed as expected!"
            ]
        ]
