module Commands exposing (..)

import Date exposing (Date)
import Http exposing (..)
import Json.Decode as JD
import Json.Decode.Extra as JDExtra
import Json.Decode.Pipeline as Pipeline
import Json.Encode as JE
import Date.Extra exposing (toUtcIsoString)
import Messages exposing (Msg(..))
import Model exposing (..)
import Task exposing (Task)


fetchTransactions : Cmd Msg
fetchTransactions =
    Http.send LoadedTransactions (Http.get transactionsUrl transactionsDecoder)


saveTransactionRequest : Model -> Date -> Task Error Transaction
saveTransactionRequest model date =
    let
        -- backend will provide id
        id =
            ""

        category =
            model.formData.categoryInput

        amount =
            Result.withDefault 0 (String.toFloat model.formData.amountInput)

        transaction =
            Transaction id date category amount
    in
        Http.post transactionsUrl
            (transactionEncoder transaction
                |> Http.jsonBody
            )
            transactionDecoder
            |> Http.toTask


deleteTransaction : String -> Cmd Msg
deleteTransaction id =
    Http.send DeletedTransaction
        (Http.request
            { method = "DELETE"
            , headers = []
            , url = transactionsUrl ++ id
            , expect = expectStringResponse (\_ -> Ok id)
            , body = emptyBody
            , timeout = Nothing
            , withCredentials = False
            }
        )


transactionsUrl : String
transactionsUrl =
    "http://localhost:4000/transactions/"


transactionEncoder : Transaction -> JE.Value
transactionEncoder transaction =
    let
        attributes =
            [ ( "id", JE.string transaction.id )
            , ( "date", JE.string (toUtcIsoString transaction.date) )
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
        |> Pipeline.required "id" JD.string
        |> Pipeline.required "date" JDExtra.date
        |> Pipeline.required "category" JD.string
        |> Pipeline.required "amount" JD.float
