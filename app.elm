module Main exposing (..)

import Window
import Time exposing (Time)
import Html exposing (..)
import Html.Attributes exposing (..)


main =
    program
        { init = ( init, Cmd.none )
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



--initCmds
-- Model


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
    | MaybeSpawnFruitFruitSpawn FruitSpawn



-- todo: block?


type alias FruitSpawn =
    { position : ( Int, Int )
    , chance : Int
    }


type Key
    = NoKey
    | Space
    | ArrowKey Direction


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



-- Update


update : Msg -> Game -> ( Game, Cmd Msg )
update msg game =
    case msg of
        KeyPressed Space ->
            ( { game | paused = not game.paused }, Cmd.none )

        KeyPressed NoKey ->
            ( game, Cmd.none )

        KeyPressed (ArrowKey direction) ->
            ( updateDirection direction game, Cmd.none )

        SizeUpdated size ->
            ( game, Cmd.none )

        Tick time ->
            ( game, Cmd.none )

        MaybeSpawnFruitFruitSpawn spawn ->
            ( game, Cmd.none )


updateDirection : Direction -> Game -> Game
updateDirection desiredDirection game =
    let
        { direction } =
            game

        newDirection =
            if oppositeDirection desiredDirection /= direction then
                desiredDirection
            else
                direction
    in
        { game | direction = newDirection }


oppositeDirection : Direction -> Direction
oppositeDirection direction =
    case direction of
        Up ->
            Down

        Right ->
            Left

        Down ->
            Up

        Left ->
            Right



-- if game.isDead || game.paused then
--     (game)
-- Subscriptions


subscriptions : Game -> Sub Msg
subscriptions game =
    Sub.none



-- View


view : Game -> Html Msg
view game =
    text "ff"
