module Tests exposing (..)

import Test exposing (..)
import Expect
import Date exposing (Month(..))
import Date.Extra as DateExtra
import Commands exposing (transactionsDecoder)


all : Test
all =
    describe "Decoding"
        [ test "Decode transaction"
            <| \() ->
                Expect.equal (JD.decodeString transactionsDecoder "[{\"id\": \"1\", \"date\": \"2017-03-05 00:00:00Z\", \"category\":\"Kiosk\", \"amount\": \"100.20\"}]")
                    (Ok (Transaction (DateExtra.fromSpec utc noTime 2017 Mar 5)))
        ]
