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


view : Model -> Html Msg
view model =
    case model.route of
        HomeRoute ->
            transactionsView model

        NotFoundRoute ->
            notFoundView


transactionsView : Model -> Html Msg
transactionsView model =
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
                    [ sumView model.transactions
                    , newTransactionForm model.formData
                    ]
                , section [ class "main" ]
                    [ ul [ class "trans-list" ]
                        (List.map transEntryView model.transactions)
                    ]
                ]
            ]
        , errorView model.state.error
        ]


errorView : Maybe String -> Html msg
errorView error =
    case error of
        Just error ->
            div [ class "errors" ] [ text ("Error: " ++ error) ]

        Nothing ->
            text ""


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not Found"
        ]


newTransactionForm : Form -> Html Msg
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
        , button [ class "add", onClick SaveTransaction ]
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
                , onClick (DeleteTransaction transaction.id)
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
