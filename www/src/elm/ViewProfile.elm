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
        { model | oldPassword = newContent }


view : Model -> Html Msg
view model =
    div [  ]
        [ div
        []
        [ h2 [] [text "Profile" ]
          , div
            []
            [ text (String.concat ["Username: ", model.currentUser.username])
            ]
          , div
            []
            [ text (String.concat ["E-mail address: ", model.currentUser.email])
            ]
          , button [] [ text "Edit profile" ]
        ]]

main : Program Never Model Msg
main =
    beginnerProgram
      { model = initialModel
      , view = view
      , update = update
      }
