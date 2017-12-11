module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http exposing (..)
--import Html.Events exposing (..)
import Json.Decode exposing (..)

type Msg =
    NewMediaList (Result Http.Error Playlist)

type alias Model =
  { playlist : Playlist, playlistId : String, error : Maybe Error }

type alias Playlist =
  { id : String,
    owner : String
    , name : String
    , mediaEntries : List MediaEntry }

type alias MediaEntry =
  { displayname: String
    , media : MediaItem
    , added: String }

type alias MediaItem =
  { name : String
    , url : String
    , lenght : Int }

playlistDecoder : Json.Decode.Decoder Playlist
playlistDecoder =
    Json.Decode.map4 Playlist
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "owner" Json.Decode.string)
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "mediaEntries"
            (Json.Decode.list
                (Json.Decode.map3 MediaEntry
                    (Json.Decode.field "displayname" Json.Decode.string)
                    (Json.Decode.field "media"
                        (Json.Decode.map3 MediaItem
                            (Json.Decode.field "name" Json.Decode.string)
                            (Json.Decode.field "url" Json.Decode.string)
                            (Json.Decode.field "lenght" Json.Decode.int)
                        )
                    )
                    (Json.Decode.field "added" Json.Decode.string)
                )
            )
        )

init : (Model, Cmd Msg)
init =
  ( initialModel, send NewMediaList <| Http.get ("http://localhost:8080/mediastreamerbe-0.0.1/api/playlist/" ++ initialModel.playlistId) playlistDecoder )

thisPlaylist : Playlist
thisPlaylist =
    {
    id = "",
      owner = ""
      , name = ""
      , mediaEntries = [] }

thisMediaEntry : MediaEntry
thisMediaEntry =
    { displayname = "", media = { name = "", url = "", lenght = 0 }, added = "" }

initialModel : Model
initialModel =
  { playlist = thisPlaylist
  , playlistId = "71396a4c-c02b-4f68-94b1-09c4607f2978"
  , error = Nothing }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
      NewMediaList (Ok newPlaylist) ->
      ( { model | playlist = newPlaylist}, Cmd.none)

      NewMediaList (Err error) ->
      ( { model | error = Just error } , Cmd.none )


view : Model -> Html Msg
view model =
    div [ style [("padding", "10px")] ]
        [ div [] [ h2 [] [ text model.playlist.name ]]
        , ol [] (List.map
          (\mentry -> li [ id "song" ] [ a [href mentry.media.url]
          [ text mentry.media.name, text " "
          -- , text (toString mentry.media.lenght)
          ], text " ", button [ id "actionbutton" ] [ text "Play"]])
          model.playlist.mediaEntries)
        , button [] [ text "Edit playlist"]
        -- , div [] [ text <| toString model.error] --For testing error
        ]

-- subscriptions : Model -> Sub Msg
-- subscriptions model =
--   Sub.none

main : Program Never Model Msg
main =
    program
      { init = init
      , view = view
      , update = update
      , subscriptions = \_ -> Sub.none -- subscriptions
      }
