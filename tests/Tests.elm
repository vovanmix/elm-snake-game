module Tests exposing (..)

import Test exposing (..)
import GameStepTest
import UpdateTest


all : Test
all =
    describe "Snake game"
        [ GameStepTest.all
        , UpdateTest.all
        ]
