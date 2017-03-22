module Subscriptions exposing (..)

import Types exposing (..)
import Time
import Keyboard
import Window


subscriptions : Game -> Sub Msg
subscriptions game =
    Sub.batch [ keyboardChanged, windowDimensionsChanged, tick ]


keyboardChanged : Sub Msg
keyboardChanged =
    Keyboard.downs toKeyChanged


windowDimensionsChanged : Sub Msg
windowDimensionsChanged =
    Window.resizes SizeUpdated


tick : Sub Msg
tick =
    Time.every (100 * Time.millisecond) Tick


toKeyChanged : Keyboard.KeyCode -> Msg
toKeyChanged code =
    case code of
        32 ->
            KeyPressed Space

        37 ->
            KeyPressed (ArrowKey Left)

        38 ->
            KeyPressed (ArrowKey Up)

        39 ->
            KeyPressed (ArrowKey Right)

        40 ->
            KeyPressed (ArrowKey Down)

        default ->
            KeyPressed NoKey
