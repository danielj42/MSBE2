module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
--import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode exposing (..)

type Msg
    = NewMediaList (Result Http.Error (List MediaEntry))

type alias Model =
  { availableMedia : List MediaEntry }

type alias MediaEntry =
  { name : String, artist : String, length : String, filename : String}

decodeMedia : Json.Decode.Decoder MediaEntry
decodeMedia =
  Json.Decode.map4 MediaEntry
      (field "name" string)
      (field "artist" string)
      (field "length" string)
      (field "filename" string)

mediaListDecoder : Json.Decode.Decoder (List MediaEntry)
mediaListDecoder =
    Json.Decode.list decodeMedia

initialModel : Model
initialModel =
  { availableMedia = []}

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      NewMediaList (Ok mediaList) ->
      ( { model | availableMedia = mediaList }, Cmd.none)

      NewMediaList (Err _) ->
      (model, Cmd.none)

view : Model -> Html Msg
view model =
    div [ id "content" ]
        [ div [] [ h2 [] [ text "Browse Audio files" ]]
        , ol [] (List.map
          (\mentry -> li [ id "song" ] [ a [href mentry.filename] [ text mentry.artist, text " - ", text mentry.name, text " ", text mentry.length ], text " ", button [ id "actionbutton" ] [ text "Play"]])
          model.availableMedia)
        , button [] [ text "New playlist"]
        ]

init : (Model, Cmd Msg)
init =
  (initialModel, send NewMediaList <| Http.get "http://localhost:3000/api/media" mediaListDecoder )

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
