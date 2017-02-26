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
    section []
        [ header []
            [ button
                [ class "menu"
                , onClick Signout
                ]
                [ text "Logout" ]
            ]
        , section [ class "centered" ]
            [ page model ]
        ]


page : Model -> Html Msg
page model =
    case model.route of
        HomeRoute ->
            mainView model

        TransactionRoute ->
            mainView model

        NotFoundRoute ->
            notFoundView


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not Found"
        ]


mainView : Model -> Html Msg
mainView model =
    main_ []
        [ div [ class "header" ]
            [ sumView model
            , newTransactionForm model
            ]
        , section [ class "main" ]
            [ ul [ class "trans-list" ]
                (List.map transEntryView model.transactions)
            ]
        ]


newTransactionForm : Model -> Html Msg
newTransactionForm model =
    Html.form [ onSubmit AddDate ]
        [ input
            [ id "category-input"
            , class "coin-input"
            , placeholder "Kategori"
            , autofocus True
            , onInput CategoryInput
            , value model.transFormState.categoryInput
            ]
            []
        , input
            [ class "coin-input"
            , placeholder "Beløp"
            , type_ "number"
            , onInput AmountInput
            , value model.transFormState.amountInput
            ]
            []
        , button [ class "add" ]
            [ text "Add" ]
        ]


calculateSum : Model -> Float
calculateSum model =
    model.transactions
        |> List.map .amount
        |> List.sum


formatSum : Float -> String
formatSum sum =
    formatWithLanguage French.lang "0,0.00" sum


sumView : Model -> Html Msg
sumView model =
    let
        sum =
            calculateSum model

        color =
            if sum < 0 then
                "red-color"
            else
                "green-color"
    in
        h1 [ class color ]
            [ text
                (model
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
            , span [] [ text (formatSum transaction.amount) ]
            , button
                [ class "delete"
                , onClick (DeleteTransaction transaction.id)
                ]
                [ text "Delete" ]
            ]
        ]


formatDate : Maybe Date -> String
formatDate date =
    case date of
        Just date ->
            let
                year =
                    date |> Date.year |> toString

                month =
                    date |> Date.month |> toString

                day =
                    date |> Date.day |> toString
            in
                year ++ "-" ++ month ++ "-" ++ day

        Nothing ->
            ""
