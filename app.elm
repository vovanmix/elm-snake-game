module Main exposing (..)

import Window
import Time exposing (Time)
import Html exposing (..)
import Html.Attributes exposing (..)
import Random


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
    | MaybeSpawnFruit FruitSpawn


type alias FruitSpawn =
    { position : Block
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
            ( { game | dimensions = size }, Cmd.none )

        Tick time ->
            gameStep game

        MaybeSpawnFruit spawn ->
            ( spawnFruit spawn game, Cmd.none )


gameStep : Game -> ( Game, Cmd Msg )
gameStep game =
    if game.isDead || game.paused then
        ( game, Cmd.none )
    else
        ( game, Cmd.none ) |> checkIfOutOfBounds |> updateFruit



-- TODO: split in multiple files
-- TODO: will this cmd overwtite the others? looks like a bad pattern!


checkIfOutOfBounds : ( Game, Cmd Msg ) -> ( Game, Cmd Msg )
checkIfOutOfBounds ( game, cmd ) =
    let
        head =
            snakeHead game.snake

        isOutOfBounds =
            headIsOutOfBounds head game.direction
    in
        ( { game | isDead = isOutOfBounds }, cmd )


snakeHead : Snake -> Block
snakeHead snake =
    List.head snake |> Maybe.withDefault (Block 0 0)


headIsOutOfBounds : Block -> Direction -> Bool
headIsOutOfBounds head dir =
    case dir of
        Up ->
            head.x == 0

        Right ->
            head.x == 49

        Down ->
            head.y == 49

        Left ->
            head.y == 0


updateFruit : ( Game, Cmd Msg ) -> ( Game, Cmd Msg )
updateFruit ( game, cmd ) =
    case game.fruit of
        Nothing ->
            ( game, Random.generate MaybeSpawnFruit fruitSpawnGenerator )

        Just fruit ->
            if game.ateFruit then
                ( { game | fruit = Nothing }, cmd )
            else
                ( game, cmd )


fruitSpawnGenerator : Random.Generator FruitSpawn
fruitSpawnGenerator =
    let
        position =
            Random.pair (Random.int 0 49) (Random.int 0 49)

        chance =
            Random.int 0 9
    in
        Random.map2 (\( x, y ) c -> FruitSpawn (Block x y) c) position chance


spawnFruit : FruitSpawn -> Game -> Game
spawnFruit spawn game =
    if spawn.chance == 9 then
        { game | fruit = Just spawn.position }
    else
        game


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
