module Main exposing (main)

import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode exposing (..)
import Json.Encode exposing (..)

type Msg
    = SetPlaylistName String
    | AddToPlayList BE2MediaEntry
    | RemoveFromPlaylist Int
    | NewMediaList (Result Http.Error (List BE2MediaEntry))

type alias Model =
    { currentUser : User
      , newPlaylist : BE2Playlist
      , availableMedia : List BE2MediaEntry
      , playlistToSend : Playlist
      , newPlaylistName : String
      , currentUserId : String }

type alias User =
    { name : String
        , email : String
        , password : String }

--DEFINITIONS FOR MONGO/EXPRESS BACKEND
type alias BE2Playlist =
    { name : String
        , mediaEntries : List BE2MediaEntry }

type alias BE2MediaEntry =
  { name : String, artist : String, length : String, filename : String }

--DEFINITIONS FOR JAVA BACKEND
type alias Playlist =
  {
  -- id : String,
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

daniel : User
daniel =
  { name = "Daniel Jonsson"
    , email = "daniel.jonsson42@gmail.com"
    , password = "hemligt" }

currentPlaylist : BE2Playlist
currentPlaylist =
    { name = "", mediaEntries = newMediaEntries }

newMediaEntries : List BE2MediaEntry
newMediaEntries =
    []

thisPlaylistToSend : Playlist
thisPlaylistToSend =
    {
    -- id = "",
      owner = "78b10b95-a0f6-4b83-96c7-df3ecefd30e5"
      , name = "Mockdata for playlist POST"
      , mediaEntries = [ thisMediaEntryToSend ] }

thisMediaEntryToSend : MediaEntry
thisMediaEntryToSend =
    { displayname = "", media = { name = "e0a73a29-89ed-4097-848d-44fb010f2a42", url = "http://127.0.0.1:6666/Cranberries.mp3", lenght = 12123123 }
    , added = "2017-12-01 09:42:23" }

initialModel : Model
initialModel =
  { currentUser = daniel
    , newPlaylist = currentPlaylist
    , availableMedia = []
    , playlistToSend = thisPlaylistToSend
    , newPlaylistName = ""
    , currentUserId = "dd6d5c19-b480-4791-b422-f3f922508b4c" }

decodeMedia : Json.Decode.Decoder BE2MediaEntry
decodeMedia =
  Json.Decode.map4 BE2MediaEntry
      (field "name" Json.Decode.string)
      (field "artist" Json.Decode.string)
      (field "length" Json.Decode.string)
      (field "filename" Json.Decode.string)

mediaListDecoder : Json.Decode.Decoder (List BE2MediaEntry)
mediaListDecoder =
    Json.Decode.list decodeMedia

mockJsonToSend : String
mockJsonToSend =
    Json.Encode.encode 0
      ( Json.Encode.object [( "owner", Json.Encode.string "78b10b95-a0f6-4b83-96c7-df3ecefd30e5" )]

      )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      SetPlaylistName newContent ->
        ( { model | newPlaylistName = newContent }, Cmd.none )
        -- ({ model | newPlaylist = { currentPlaylist | name = newContent } }, Cmd.none)

      AddToPlayList newentry ->
        ({ model | newPlaylist = { currentPlaylist | mediaEntries = newentry :: model.newPlaylist.mediaEntries } }, Cmd.none)

      RemoveFromPlaylist i ->
        ({ model | newPlaylist = { currentPlaylist | mediaEntries = (List.take i model.newPlaylist.mediaEntries) ++ (List.drop (i+1) model.newPlaylist.mediaEntries) } }, Cmd.none)

      NewMediaList (Ok mediaList) ->
        ( { model | availableMedia = mediaList }, Cmd.none )

      NewMediaList (Err _) ->
        ( model, Cmd.none )

view : Model -> Html Msg
view model =
    div [ id "content" ]
        [ div [] [ h2 [] [ text "Edit/create playlist:" ]]
        , div [] [ text "Enter title: "
          , input [ id "input", onInput SetPlaylistName ] []
          ]
        , ol [] (List.map
          (\mentry -> li [ id "song" ] [ a [href mentry.filename] [ text mentry.artist, text " - ", text mentry.name, text " ", text mentry.length ], text " ", button [ id "actionbutton", onClick (AddToPlayList mentry) ] [ text "Add" ]])
          model.availableMedia)
        , div [] [ h2 [] [text (String.concat [ "Files added to playlist \"", model.newPlaylistName, "\":"] )]]
        , ol [] (List.map
          (\(songIndex, mentry) -> li [ id "song" ] [ text mentry.artist, text " - ", text mentry.name, text " ", button [ id "actionbutton", onClick (RemoveFromPlaylist songIndex) ] [ text "Remove" ]])
          (toIndexedList (fromList model.newPlaylist.mediaEntries)))
        , button [] [ text "Save Changes" ]
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
      { init = init
      , view = view
      , update = update
      , subscriptions = subscriptions
      }
