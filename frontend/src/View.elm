module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Model exposing (..)
import Update exposing (Msg)
import Routing exposing (Route(..))
import Transaction


view : Model -> Html Msg
view model =
    section []
        [ header []
            [ button
                [ class "menu"
                , onClick Update.Signout
                ]
                [ text "Logout" ]
            ]
        , section
            [ class "centered" ]
            [ page model
            ]
        ]


page : Model -> Html Msg
page model =
    case model.route of
        HomeRoute ->
            Html.map Update.TransactionMsg (Transaction.mainView model.transactions)

        TransactionRoute ->
            Html.map Update.TransactionMsg (Transaction.mainView model.transactions)

        NotFoundRoute ->
            notFoundView


notFoundView : Html msg
notFoundView =
    div
        []
        [ text "Not Found"
        ]
