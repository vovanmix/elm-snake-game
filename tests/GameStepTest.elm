module GameStepTest exposing (all)

import Test exposing (..)
import Expect
import GameStep
import Types exposing (..)


all : Test
all =
    describe "GameStep"
        [ testHeadIsOutOfBounds
        , testMoveBlock
        ]


testHeadIsOutOfBounds : Test
testHeadIsOutOfBounds =
    describe
        "#headIsOutOfBounds"
        [ test "head is inside of the board" <|
            \() ->
                Expect.equal False
                    (GameStep.headIsOutOfBounds (Block 1 2) Up)
        , test "head is in the top row moving up" <|
            \() ->
                Expect.equal True
                    (GameStep.headIsOutOfBounds (Block 2 0) Up)
        , test "head is in the bottom row moving down" <|
            \() ->
                Expect.equal True
                    (GameStep.headIsOutOfBounds (Block 2 49) Down)
        , test "head is in the left col moving left" <|
            \() ->
                Expect.equal True
                    (GameStep.headIsOutOfBounds (Block 0 2) Left)
        , test "head is in the right col moving right" <|
            \() ->
                Expect.equal True
                    (GameStep.headIsOutOfBounds (Block 49 2) Right)
        ]


testMoveBlock : Test
testMoveBlock =
    describe "#moveBlock"
        [ test "moves up" <|
            \() ->
                Expect.equal (Block 1 1)
                    (GameStep.moveBlock (Block 1 2) Up)
        ]
