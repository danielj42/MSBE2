module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

type Msg
    = UpdateNewUsername String | UpdateEmail String | UpdateNewPassword1 String | UpdateNewPassword2 String | UpdateOldPassword String

type alias Model =
  { currentUser : User, newUsername : String, newEmail : String, newPassword1 : String, newPassword2 : String, oldPassword : String }

type alias User =
  { username : String, email : String, password : String }

initialModel : Model
initialModel =
  { currentUser = { username = "Daniel Jonsson", email = "daniel.jonsson42@gmail.com", password = "hemligt" }, newUsername = "Daniel Jonsson", newEmail = "daniel.jonsson42@gmail.com", newPassword1 = "", newPassword2 = "", oldPassword = "" }

update : Msg -> Model -> Model
update msg model =
    case msg of
      UpdateNewUsername newContent ->
        { model | newUsername = newContent }

      UpdateEmail newContent ->
        { model | newEmail = newContent }

      UpdateNewPassword1 newContent ->
        { model | newPassword1 = newContent }

      UpdateNewPassword2 newContent ->
        { model | newPassword2 = newContent }

      UpdateOldPassword newContent ->
        { model | currentUser = { model.currentUser | ... }, oldPassword = newContent }


view : Model -> Html Msg
view model =
    div [  ]
        [ div
        []
        [ text "Username: ",  input
          [ size 35, value model.newUsername, onInput UpdateNewUsername ]
          []
        ]
       , div
        []
        [ text "E-mail address: ",  input
          [ size 35, value model.newEmail, onInput UpdateEmail ]
          []
        , div
          []
          [ button
            []
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
              [ type_ "password", size 35, onInput UpdateNewPassword1 ]
              []
            ]
          , div
            []
            [ text "Repeat new password: ",  input
              [ type_ "password", size 35, onInput UpdateNewPassword2 ]
              []
            ]
          , div
            []
            [ text "Old password: ",  input
              [ type_ "password", size 35, onInput UpdateOldPassword ]
              []
            ]
          , button
            []
            [ text "Change password" ]
          ]
        ]
        , div [] [text "Current user: ", text (toString model.currentUser)]
        , div [] [text (String.concat ["Changed user: ", model.newUsername, " ", model.newEmail, " new pw 1:", model.newPassword1, ", new pw 2: ", model.newPassword2, " old pw: ", model.oldPassword]) ]
        ]

main : Program Never Model Msg
main =
    beginnerProgram
      { model = initialModel
      , view = view
      , update = update
      }
