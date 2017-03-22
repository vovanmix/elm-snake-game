module View exposing (..)

import Window
import Html exposing (..)
import Html.Attributes exposing (style)
import Types exposing (..)
import Svg exposing (Svg, Attribute, svg, rect, defs, filter, feGaussianBlur, feMerge, feMergeNode)
import Svg.Attributes exposing (width, height, viewBox, x, y, rx, fill, id, stdDeviation, result)


view : Game -> Html Msg
view game =
    let
        ( scaledWidth, scaledHeight ) =
            scale game.dimensions

        parentStyle =
            style [ ( "margin", "0 auto" ), ( "display", "block" ) ]
    in
        svg
            [ width scaledWidth, height scaledHeight, viewBox "0 0 50 50", parentStyle ]
            ([ renderBackground ]
                ++ renderSnake game.snake
                ++ renderFruit game.fruit
            )


renderSnake : Snake -> List (Svg Msg)
renderSnake snake =
    List.map (renderBlock snakeColor) snake


renderBlock : Svg.Attribute Msg -> Block -> Svg Msg
renderBlock color block =
    let
        ( strX, strY ) =
            ( block.x |> toString, block.y |> toString )
    in
        rect [ x strX, y strY, width "1", height "1", color ] []


renderFruit : Maybe Block -> List (Svg Msg)
renderFruit block =
    case block of
        Nothing ->
            []

        Just fruit ->
            [ renderBlock
                fruitColor
                fruit
            ]


renderBackground : Svg Msg
renderBackground =
    rect [ x "0", y "0", width size, height size, backgroundColor ] []


size : String
size =
    "100"


backgroundColor : Svg.Attribute Msg
backgroundColor =
    fill "#333333"


snakeColor : Svg.Attribute Msg
snakeColor =
    fill "#00bbcc"


fruitColor : Svg.Attribute Msg
fruitColor =
    fill "#44ff44"


scale : Window.Size -> ( String, String )
scale size =
    let
        toPixelStr =
            \i -> round i |> toString

        ( fWidth, fHeight ) =
            ( toFloat size.width, toFloat size.height )

        ( scaledX, scaledY ) =
            if fWidth > fHeight then
                ( fHeight / fWidth, 1.0 )
            else if fHeight == 0 then
                ( 1.0, 1.0 )
            else
                ( 1.0, fWidth / fHeight )
    in
        ( toPixelStr (fWidth * scaledX), toPixelStr (fHeight * scaledY) )
