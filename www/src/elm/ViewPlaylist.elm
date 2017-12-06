module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Html.Events exposing (..)
import Json.Decode exposing (..)

type Msg
    = Click | NewMediaList (Result Http.Error (List MediaEntry))

type alias Model =
  { media : List MediaEntry, playlistTitle : String }

type alias MediaEntry =
  { name : String,
    filename : String,
    artist: String }


decodeMedia : Json.Decode.Decoder MediaEntry
decodeMedia =
  Json.Decode.map3 MediaEntry
      (field "name" string)
      (field "filename" string)
      (field "artist" string)

mediaListDecoder : Json.Decode.Decoder (List MediaEntry)
mediaListDecoder =
    Json.Decode.list decodeMedia

init : (Model, Cmd Msg)
init =
  (initialModel, Cmd.none)

initialModel : Model
initialModel =
  { media = []
  , playlistTitle = "My Playlist" }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
      Click ->
      ( model, getMediaItems )

      NewMediaList (Ok mediaList) ->
      ( { model | media = mediaList}, Cmd.none)

      NewMediaList (Err _) ->
      (model, Cmd.none)

getMediaItems : Cmd Msg
getMediaItems =
  Http.send NewMediaList <|
    Http.get "http://localhost:3000/api/media" mediaListDecoder


view : Model -> Html Msg
view model =
    div [  ]
        [ div [] [ h2 [] [ text model.playlistTitle ]]
        , ol [] (List.map
          (\mentry -> li [] [ a [href mentry.filename] [ text mentry.artist
          , text " - ", text mentry.name ], text " ", button [] [ text "Play"]])
          model.media)
        , button [] [ text "Edit playlist"]
        , button [ onClick Click ] [ text "Get media from url"]
        ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

main : Program Never Model Msg
main =
    program
      { init = init
      , view = view
      , update = update
      , subscriptions = subscriptions
      }
