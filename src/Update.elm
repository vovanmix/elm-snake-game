module Update exposing (..)

import Types exposing (..)
import GameStep exposing (..)


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
