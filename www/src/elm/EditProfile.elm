module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode exposing (..)

type Msg
    = UpdateNewUsername String
    | UpdateEmail String
    | UpdateNewPassword1 String
    | UpdateNewPassword2 String
    | UpdateOldPassword String
    | UserFromDB (Result Http.Error User)

type alias Model =
  { currentUserName : String, currentUserEmail : String, newUserName : String, newEmail : String, newPassword1 : String, newPassword2 : String, oldPassword : String, currentUserId : String, error : Maybe Error  }

type alias User =
  { userName : String, email : String, id : String }

initialModel : Model
initialModel =
  { currentUserName = "", currentUserEmail = "", newUserName = "", newEmail = "", newPassword1 = "", newPassword2 = "", oldPassword = "", currentUserId = "dd6d5c19-b480-4791-b422-f3f922508b4c", error = Nothing  }

-- thisCurrentUser : User
-- thisCurrentUser =
--   { userName = "", email = "", id = "test" }
--
-- thisNewUser : User
-- thisNewUser =
--   { userName = "", email = "", id = "test" }

decodeUser : Json.Decode.Decoder User
decodeUser =
  Json.Decode.map3 User
      (field "userName" string)
      (field "email" string)
      (field "id" string)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      UpdateNewUsername newContent ->
          ( { model | currentUserName = newContent }, Cmd.none)

      UpdateEmail newContent ->
        ( { model | currentUserEmail = newContent }, Cmd.none)

      UpdateNewPassword1 newContent ->
        ( { model | newPassword1 = newContent }, Cmd.none)

      UpdateNewPassword2 newContent ->
        ( { model | newPassword2 = newContent }, Cmd.none)

      UpdateOldPassword newContent ->
        ( { model | oldPassword = newContent }, Cmd.none)

      UserFromDB (Ok gottenUser) ->
        ( { model | currentUserName = gottenUser.userName, currentUserEmail = gottenUser.email }, Cmd.none)

      UserFromDB (Err error) ->
        ( { model | error = Just error } , Cmd.none )


view : Model -> Html Msg
view model =
    div [ id "content" ]
        [ div
        []
        [ text "Username: ",  input
          [ id "input", size 35, Html.Attributes.value model.currentUserName, onInput UpdateNewUsername ]
          []
        ]
       , div
        []
        [ text "E-mail address: ",  input
          [ id "input", size 35, Html.Attributes.value model.currentUserEmail, onInput UpdateEmail ]
          []
        , div
          []
          [ button
            [ id "button" ]
            [ text "Save changes" ]
          , br
            []
            []
          , br
            []
            []
          , div
            []
            [ text "New password: ",  input
              [ id "input", type_ "password", size 35, onInput UpdateNewPassword1 ]
              []
            ]
          , div
            []
            [ text "Repeat new password: ",  input
              [ id "input", type_ "password", size 35, onInput UpdateNewPassword2 ]
              []
            ]
          , div
            []
            [ text "Old password: ",  input
              [ id "input", type_ "password", size 35, onInput UpdateOldPassword ]
              []
            ]
          , button
            [ id "button" ]
            [ text "Change password" ]
          ]
        ]
        , div [] [text "Current user: ", text (String.concat [ model.currentUserName,  ", " , model.currentUserEmail ]) ]
        , div [] [text (String.concat [ "New pw 1:", model.newPassword1, ", new pw 2: ", model.newPassword2, " old pw: ", model.oldPassword]) ]
        ]

init : (Model, Cmd Msg)
init =
  ( initialModel, send UserFromDB <| Http.get ( "http://localhost:8080/mediastreamerbe-0.0.1/api/user/" ++ initialModel.currentUserId) decodeUser )

main : Program Never Model Msg
main =
    program
      { init = init
      , view = view
      , update = update
      , subscriptions = \_ -> Sub.none
      }
