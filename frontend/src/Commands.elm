module Commands exposing (..)

import Http
import Json.Decode as JD
import Json.Decode.Extra as JDExtra
import Json.Decode.Pipeline as Pipeline
import Messages exposing (Msg)
import Model exposing (Transaction)
import RemoteData


fetchTransactions : Cmd Msg
fetchTransactions =
    Http.get fetchTransactionsUrl transactionsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Messages.LoadTransactions


fetchTransactionsUrl : String
fetchTransactionsUrl =
    "http://localhost:4000/transactions"


transactionsDecoder : JD.Decoder (List Transaction)
transactionsDecoder =
    JD.list transactionDecoder


transactionDecoder : JD.Decoder Transaction
transactionDecoder =
    Pipeline.decode Transaction
        |> Pipeline.required "id" JD.string
        |> Pipeline.required "date" JDExtra.date
        |> Pipeline.required "category" JD.string
        |> Pipeline.required "amount" JD.float
