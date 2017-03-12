module View exposing (..)

import Date exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Numeral exposing (formatWithLanguage)
import Languages.French as French
import Routing exposing (Route(..))
import RemoteData exposing (WebData, RemoteData(..))


view : Model -> Html Msg
view model =
    case model.route of
        HomeRoute ->
            checkLoadStateView model

        NotFoundRoute ->
            notFoundView


checkLoadStateView : Model -> Html Msg
checkLoadStateView model =
    case model.transactions of
        NotAsked ->
            text "Initialising..."

        Loading ->
            text "Loading transactions..."

        Failure err ->
            text ("Error: " ++ toString err)

        Success transactions ->
            transactionsView transactions model.transFormState


transactionsView : List Transaction -> Model.TransactionForm -> Html Msg
transactionsView transactions formData =
    section []
        [ header []
            [ button
                [ class "menu"
                , onClick Signout
                ]
                [ text "Login" ]
            ]
        , section [ class "centered" ]
            [ main_ []
                [ div [ class "header" ]
                    [ sumView transactions
                    , newTransactionForm formData
                    ]
                , section [ class "main" ]
                    [ ul [ class "trans-list" ]
                        (List.map transEntryView transactions)
                    ]
                ]
            ]
        ]


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not Found"
        ]


newTransactionForm : TransactionForm -> Html Msg
newTransactionForm formData =
    Html.form []
        [ input
            [ id "category-input"
            , class "coin-input"
            , placeholder "Kategori"
            , autofocus True
            , onInput CategoryInput
            , value formData.categoryInput
            ]
            []
        , input
            [ class "coin-input"
            , placeholder "Beløp"
            , type_ "number"
            , onInput AmountInput
            , value formData.amountInput
            ]
            []
        , button [ class "add" ]
            [ text "Add" ]
        ]


calculateSum : List Transaction -> Float
calculateSum transactions =
    transactions
        |> List.map .amount
        |> List.sum


formatSum : Float -> String
formatSum sum =
    formatWithLanguage French.lang "0,0.00" sum


sumView : List Transaction -> Html Msg
sumView transactions =
    let
        sum =
            calculateSum transactions

        color =
            if sum < 0 then
                "red-color"
            else
                "green-color"
    in
        h1 [ class color ]
            [ text
                (transactions
                    |> calculateSum
                    |> formatSum
                )
            ]


transEntryView : Transaction -> Html Msg
transEntryView transaction =
    li []
        [ div [ class "view" ]
            [ span [] [ text (formatDate transaction.date) ]
            , span [] [ text transaction.category ]
            , span [] [ text (toString transaction.amount) ]
            , button
                [ class "delete"
                ]
                [ text "Delete" ]
            ]
        ]


formatDate : Date -> String
formatDate date =
    let
        year =
            date |> Date.year |> toString

        month =
            date |> Date.month |> toString

        day =
            date |> Date.day |> toString
    in
        year ++ "-" ++ month ++ "-" ++ day
