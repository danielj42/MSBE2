module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
--import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode exposing (..)

type Msg
    = NewListOfPlaylists (Result Http.Error PlaylistContainer)

type alias Model =
  { playlists : PlaylistContainer, userId: String, error : Maybe Error }

type alias PlaylistContainer =
  { listOfPlaylists : List Playlist }

type alias Playlist =
  { id : String, ownerId: String, name : String, items : Int }

initialModel : Model
initialModel =
  { playlists = thisPlaylistContainer , userId = "dd6d5c19-b480-4791-b422-f3f922508b4c"
  , error = Nothing }

thisPlaylistContainer : PlaylistContainer
thisPlaylistContainer =
  { listOfPlaylists = [] }

playlistDecoder : Json.Decode.Decoder PlaylistContainer
playlistDecoder =
    Json.Decode.map PlaylistContainer
        (Json.Decode.field "playlists"
            (Json.Decode.list
                (Json.Decode.map4 Playlist
                    (Json.Decode.field "id" Json.Decode.string)
                    (Json.Decode.field "ownerId" Json.Decode.string)
                    (Json.Decode.field "name" Json.Decode.string)
                    (Json.Decode.field "items" Json.Decode.int)
                )
            )
        )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
      NewListOfPlaylists (Ok newPlaylists) ->
      ( { model | playlists = newPlaylists}, Cmd.none)

      NewListOfPlaylists (Err error) ->
      ( { model | error = Just error } , Cmd.none )


view : Model -> Html Msg
view model =
    div [ id "sidebar" ]
        [ div [] [ a [href ""] [ text "Profile" ]]
        , div [] [ a [href ""] [ text "New Playlist" ]]
        , h3 [] [ text "Browse media:" ]
        , ul [] [ li [] [ a [href ""] [ text "Audio" ]]
          , li [ style [ ("color", "grey")] ] [ text "Video" ]
          ]
        , h3 [] [ text "Playlists:" ]
        , div [] [text "Sort by:", select
        []
        [ option
          []
          [ text "Title: a-z" ]
        , option
          []
          [ text "Title: z-a" ]
        , option
          []
          [ text "Date added: newest first" ]
        , option
          []
          [ text "Date added: oldest first" ]
        ]]
        , ul
        []
        (List.map
            (\list -> li [] [ a [href ""] [ text list.name, text " "] ])
            (List.filter (\playlist -> playlist.ownerId == model.userId) model.playlists.listOfPlaylists))
        -- , div [] [ text <| toString model.error] --For testing error
        ]

init : (Model, Cmd Msg)
init =
  ( initialModel, send NewListOfPlaylists <| Http.get "http://localhost:8080/mediastreamerbe-0.0.1/api/playlist/" playlistDecoder )

main : Program Never Model Msg
main =
    program
      { init = init
      , view = view
      , update = update
      , subscriptions = \_ -> Sub.none
      }
