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
    case model.auth of
        Checking ->
            viewCheckingAuth

        LoggedIn ->
            viewRouter model

        LoggedOut ->
            loginView


viewCheckingAuth : Html Msg
viewCheckingAuth =
    text "Checking credentials..."


viewRouter : Model -> Html Msg
viewRouter model =
    case Debug.log "viewRouter" model.route of
        HomeRoute ->
            transactionsView model

        TransactionRoute ->
            transactionsView model

        NotFoundRoute ->
            notFoundView

        SignupRoute ->
            signupView

        LoginRoute ->
            loginView


signupView : Html Msg
signupView =
    Html.form []
        [ label [ for "email-input" ] [ text "Email" ]
        , input
            [ id "email-input"
            , class "u-half-width"
            , type_ "email"
            , placeholder "your@email.com"
            ]
            []
        , label [ for "password-input" ] [ text "Password" ]
        , input
            [ id "password-input"
            , class "u-half-width"
            , type_ "password"
            , placeholder "Chose password"
            ]
            []
        , div []
            [ input
                [ id "verify-password-input"
                , class "u-half-width"
                , type_ "password"
                , placeholder "Repeat password"
                ]
                []
            ]
        , div [] [ button [ type_ "submit" ] [ text "Sign up" ] ]
        , div [] [ a [ onClick (NewUrl "login") ] [ text "Login" ] ]
        ]


loginView : Html Msg
loginView =
    Html.form []
        [ label [ for "email-input" ] [ text "Email" ]
        , input
            [ id "email-input"
            , class "u-half-width"
            , type_ "email"
            , placeholder "your@email.com"
            ]
            []
        , label [ for "password-input" ] [ text "Password" ]
        , input
            [ id "password-input"
            , class "u-half-width"
            , type_ "password"
            , placeholder "************"
            ]
            []
        , div [] [ button [ type_ "submit" ] [ text "Log in" ] ]
        , div [] [ a [ onClick (NewUrl "signup") ] [ text "Sign up" ] ]
        ]


transactionsView : Model -> Html Msg
transactionsView model =
    section []
        [ header []
            [ button
                [ class "menu"
                , onClick Signout
                ]
                [ text "Logout" ]
            ]
        , section [ class "centered" ]
            [ main_ []
                [ div [ class "header" ]
                    [ sumView model.transactions
                    , newTransactionForm model.transactionForm
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


newTransactionForm : TransactionForm -> Html Msg
newTransactionForm transactionForm =
    Html.form []
        [ input
            [ id "category-input"
            , class "coin-input"
            , placeholder "Kategori"
            , autofocus True
            , onInput CategoryInput
            , value transactionForm.category
            ]
            []
        , input
            [ class "coin-input"
            , placeholder "Beløp"
            , type_ "number"
            , onInput AmountInput
            , value transactionForm.amount
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
