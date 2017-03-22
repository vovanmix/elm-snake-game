module Main exposing (..)

import Html exposing (program)
import Window
import Task
import Update
import Types exposing (..)
import Subscriptions
import View


main =
    program
        { init = ( init, initCmds )
        , update = Update.update
        , view = View.view
        , subscriptions = Subscriptions.subscriptions
        }


initCmds : Cmd Msg
initCmds =
    Task.perform SizeUpdated Window.size


init : Game
init =
    { direction = Up
    , dimensions = Window.Size 0 0
    , snake = initSnake
    , isDead = False
    , fruit = Nothing
    , ateFruit = False
    , paused = False
    }


initSnake : Snake
initSnake =
    [ Block 25 25
    , Block 25 26
    , Block 25 27
    ]
