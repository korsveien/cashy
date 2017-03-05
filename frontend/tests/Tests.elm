module Tests exposing (..)

import Test exposing (..)
import Expect
import Date exposing (Month(..))
import Date.Extra as DateExtra
import Commands exposing (transactionDecoder)
import Json.Decode as JD
import Model exposing (Transaction)


all : Test
all =
    describe "JSON decoders"
        [ test "Decoding transaction type"
            <| \() ->
                Expect.equal
                    (JD.decodeString transactionDecoder
                        "{\"id\": \"1\", \"date\": \"2017-03-05 00:00:00Z\", \"category\":\"Kiosk\", \"amount\": 100.20}"
                    )
                    (Ok
                        (Transaction "1"
                            (DateExtra.fromSpec DateExtra.utc
                                (DateExtra.atTime 0 0 0 0)
                                (DateExtra.calendarDate 2017 Mar 5)
                            )
                            "Kiosk"
                            100.2
                        )
                    )
        ]
