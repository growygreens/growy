module AllTests exposing (..)

import Test exposing (..)
import DomainTests
import CatalogTests
import RequestDataTests

all : Test
all =
    describe "Unit test suite"
        [ CatalogTests.tests
        , DomainTests.tests
        , RequestDataTests.tests
        ]
