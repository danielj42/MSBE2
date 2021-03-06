module Main exposing (main)

import Html exposing (..)
-- import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode exposing (..)
import Html.Attributes exposing (..)

type Msg
    = NoOp
    | UserFromDB (Result Http.Error User)

type alias Model =
  { currentUser : User , currentUserId : String, error : Maybe Error }

type alias User =
  { userName : String, email : String, id : String }

thisUser : User
thisUser = { userName = "", email = "", id = "" }

decodeUser : Json.Decode.Decoder User
decodeUser =
  Json.Decode.map3 User
      (field "userName" string)
      (field "email" string)
      (field "id" string)

initialModel : Model
initialModel =
  { currentUser = thisUser , currentUserId = "dd6d5c19-b480-4791-b422-f3f922508b4c", error = Nothing } --For testing the GET endpoint, this id will vary of course

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      NoOp ->
          ( model, Cmd.none )

      UserFromDB (Ok gottenUser) ->
        ( { model | currentUser = gottenUser }, Cmd.none)

      UserFromDB (Err error) ->
        ( { model | error = Just error } , Cmd.none )


view : Model -> Html Msg
view model =
    div [ id "content" ]
        [ div
        []
        [ h2 [] [text "Profile" ]
          , div
            [ id "song" ]
            [ text (String.concat ["Username: ", model.currentUser.userName])
            ]
          , div
            [ id "song" ]
            [ text (String.concat ["E-mail address: ", model.currentUser.email])
            ]
          , br [] []
          , button [] [ text "Edit profile" ]
          --, div [] [ text <| toString model.error] --For testing error
        ]]

init : (Model, Cmd Msg)
init =
  ( initialModel, send UserFromDB <| Http.get ("http://localhost:8080/mediastreamerbe-0.0.1/api/user/" ++ initialModel.currentUserId) decodeUser )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

main : Program Never Model Msg
main =
    program
      { view = view
      , init = init
      , update = update
      , subscriptions = subscriptions
      }
