module Types exposing (..)

import Window
import Time exposing (Time)


type alias Game =
    { direction : Direction
    , dimensions : Window.Size
    , snake : Snake
    , isDead : Bool
    , fruit : Maybe Block
    , ateFruit : Bool
    , paused : Bool
    }


type alias Block =
    { x : Int, y : Int }


type alias Snake =
    List Block


type Direction
    = Up
    | Right
    | Down
    | Left


type Msg
    = KeyPressed Key
    | SizeUpdated Window.Size
    | Tick Time
    | MaybeSpawnFruit FruitSpawn


type alias FruitSpawn =
    { position : Block
    , chance : Int
    }


type Key
    = NoKey
    | Space
    | ArrowKey Direction
