module Transaction exposing (..)

import Date exposing (Date)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Numeral exposing (formatWithLanguage)
import Languages.French as French
import String exposing (toFloat)
import Json.Decode as Json
import Task


type alias Transaction =
    { id : Int
    , date : Date
    , category : String
    , amount : Float
    }


type alias Model =
    { categoryInput : String
    , amountInput : String
    , transactions : List Transaction
    }


type Msg
    = AddDate
    | AddTransaction Date
    | DeleteTransaction Int
    | CategoryInput String
    | AmountInput String


parseAmount : String -> Float
parseAmount amount =
    Result.withDefault 0 (String.toFloat amount)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddTransaction date ->
            let
                id =
                    List.length model.transactions + 1

                amount =
                    parseAmount model.amountInput

                category =
                    model.categoryInput
            in
                ( { model
                    | transactions = Transaction id date category amount :: model.transactions
                    , categoryInput = ""
                    , amountInput = ""
                  }
                , Cmd.none
                )

        AddDate ->
            ( model, Task.perform AddTransaction Date.now )

        DeleteTransaction id ->
            ( { model | transactions = List.filter (\trans -> trans.id /= id) model.transactions }, Cmd.none )

        CategoryInput input ->
            ( { model | categoryInput = input }, Cmd.none )

        AmountInput input ->
            ( { model | amountInput = input }, Cmd.none )


mainView : Model -> Html Msg
mainView model =
    main_ []
        [ div
            [ class "header" ]
            [ sumView model
            , newTransactionForm model
            ]
        , section
            [ class "main" ]
            [ ul
                [ class "trans-list" ]
                (List.map transEntryView model.transactions)
            ]
        ]


newTransactionForm : Model -> Html Msg
newTransactionForm model =
    Html.form
        [ onSubmit AddDate ]
        [ input
            [ id "category-input"
            , class "coin-input"
            , placeholder "Kategori"
            , autofocus True
            , onInput CategoryInput
            , value model.categoryInput
            ]
            []
        , input
            [ class "coin-input"
            , placeholder "Beløp"
            , type_ "number"
            , onInput AmountInput
            , value model.amountInput
            ]
            []
        , button
            [ class "add" ]
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
        [ div
            [ class "view" ]
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
