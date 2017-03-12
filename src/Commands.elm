module Commands exposing (..)

import Http
import Json.Decode as JD
import Json.Decode.Extra as JDExtra
import Json.Decode.Pipeline as Pipeline
import Json.Encode as JE
import Date.Extra exposing (toUtcIsoString)
import Messages exposing (Msg)
import Model exposing (Transaction)
import RemoteData


fetchTransactions : Cmd Msg
fetchTransactions =
    Http.get transactionsUrl transactionsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Messages.LoadTransactions


transactionsUrl : String
transactionsUrl =
    "http://localhost:4000/transactions"


transactionEncoder : Transaction -> JE.Value
transactionEncoder transaction =
    let
        attributes =
            [ ( "date", JE.string (toUtcIsoString transaction.date) )
            , ( "category", JE.string transaction.category )
            , ( "amount", JE.float transaction.amount )
            ]
    in
        JE.object attributes


transactionsDecoder : JD.Decoder (List Transaction)
transactionsDecoder =
    JD.list transactionDecoder


transactionDecoder : JD.Decoder Transaction
transactionDecoder =
    Pipeline.decode Transaction
        |> Pipeline.required "date" JDExtra.date
        |> Pipeline.required "category" JD.string
        |> Pipeline.required "amount" JD.float
