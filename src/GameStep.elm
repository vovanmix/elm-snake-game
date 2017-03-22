module GameStep exposing (..)

import Random
import Types exposing (..)


gameStep : Game -> ( Game, Cmd Msg )
gameStep game =
    -- TODO: pipeline (map, combine?) the commands or split to multiple functions?
    if game.isDead || game.paused then
        ( game, Cmd.none )
    else if checkIfOutOfBounds game || checkIfEatenSelf game then
        ( { game | isDead = True }, Cmd.none )
    else
        ( game, Cmd.none )
            |> updateAteFruit
            |> updateSnake
            |> updateFruit


checkIfOutOfBounds : Game -> Bool
checkIfOutOfBounds game =
    headIsOutOfBounds
        (snakeHead game.snake)
        game.direction


checkIfEatenSelf : Game -> Bool
checkIfEatenSelf game =
    -- TODO: test that this is never called if the first is true
    let
        head =
            snakeHead game.snake

        tail =
            List.drop 1 game.snake
    in
        List.any
            (samePosition head)
            tail


updateAteFruit : ( Game, Cmd Msg ) -> ( Game, Cmd Msg )
updateAteFruit ( game, cmd ) =
    -- TODO: don't really need the cmd
    let
        head =
            snakeHead game.snake

        ateFruit =
            case game.fruit of
                Nothing ->
                    False

                Just fruit ->
                    samePosition fruit head
    in
        ( { game | ateFruit = ateFruit }, cmd )


updateSnake : ( Game, Cmd Msg ) -> ( Game, Cmd Msg )
updateSnake ( game, cmd ) =
    -- TODO: don't really need the cmd
    let
        new_head =
            moveBlock (snakeHead game.snake) game.direction

        new_tail =
            newTail game.snake game.ateFruit
    in
        ( { game | snake = new_head :: new_tail }, cmd )


updateFruit : ( Game, Cmd Msg ) -> ( Game, Cmd Msg )
updateFruit ( game, cmd ) =
    -- TODO: the only one to make a CMD change
    case game.fruit of
        Nothing ->
            ( game, Random.generate MaybeSpawnFruit fruitSpawnGenerator )

        Just fruit ->
            if game.ateFruit then
                ( { game | fruit = Nothing }, cmd )
            else
                ( game, cmd )



-- HELPERS


newTail : Snake -> Bool -> Snake
newTail snake ateFruit =
    if ateFruit then
        snake
    else
        List.take ((List.length snake) - 1) snake


moveBlock : Block -> Direction -> Block
moveBlock block dir =
    case dir of
        Up ->
            { block | y = block.y - 1 }

        Right ->
            { block | x = block.x + 1 }

        Down ->
            { block | y = block.y + 1 }

        Left ->
            { block | x = block.x - 1 }


fruitSpawnGenerator : Random.Generator FruitSpawn
fruitSpawnGenerator =
    let
        position =
            Random.pair (Random.int 0 49) (Random.int 0 49)

        chance =
            Random.int 0 9
    in
        Random.map2 (\( x, y ) c -> FruitSpawn (Block x y) c) position chance


samePosition : Block -> Block -> Bool
samePosition a b =
    a.x == b.x && a.y == b.y


snakeHead : Snake -> Block
snakeHead snake =
    List.head snake |> Maybe.withDefault (Block 0 0)


headIsOutOfBounds : Block -> Direction -> Bool
headIsOutOfBounds head dir =
    case dir of
        Up ->
            head.y == 0

        Right ->
            head.x == 49

        Down ->
            head.y == 49

        Left ->
            head.x
                == 0
