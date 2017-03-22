module UpdateTest exposing (all)

import Test exposing (..)
import Expect
import Update
import Window
import Types exposing (..)


all : Test
all =
    describe "Update"
        [ testSpawnFruit ]


testSpawnFruit : Test
testSpawnFruit =
    describe
        "#spawnFruit"
        [ test "spawns a fruit in the right position if the chance is 9" <|
            \() ->
                Expect.equal
                    { direction = Up
                    , dimensions = Window.Size 0 0
                    , snake = [ Block 1 1 ]
                    , isDead = False
                    , fruit = Just (Block 2 2)
                    , ateFruit = False
                    , paused = False
                    }
                    (Update.spawnFruit (FruitSpawn (Block 2 2) 9)
                        { direction = Up
                        , dimensions = Window.Size 0 0
                        , snake = [ Block 1 1 ]
                        , isDead = False
                        , fruit = Nothing
                        , ateFruit = False
                        , paused = False
                        }
                    )
        , test "does not spawn a fruit if the chance is different from 9" <|
            \() ->
                Expect.equal
                    { direction = Up
                    , dimensions = Window.Size 0 0
                    , snake = [ Block 1 1 ]
                    , isDead = False
                    , fruit = Nothing
                    , ateFruit = False
                    , paused = False
                    }
                    (Update.spawnFruit (FruitSpawn (Block 2 2) 8)
                        { direction = Up
                        , dimensions = Window.Size 0 0
                        , snake = [ Block 1 1 ]
                        , isDead = False
                        , fruit = Nothing
                        , ateFruit = False
                        , paused = False
                        }
                    )
        ]
