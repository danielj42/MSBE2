module Main exposing (main)

import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

type Msg
    = SetPlaylistName String
    | AddToPlayList String
    | RemoveFromPlaylist Int

type alias Model =
  { media : List MediaEntry, playlistListTitle : String, addedFiles : List String }

type alias MediaEntry =
  { name : String, filename : String }

initialModel : Model
initialModel =
  { media = [{ name = "Debussy - Clair de Lune", filename = "debussy-clair-de-lune.mp3" }, { name = "Bach - Toccata and Fugue", filename = "Toccata-and-Fugue-Dm.mp3" }, { name = "Beethoven - Für Elise", filename = "fur-elise.mp3" }]
  , playlistListTitle = "", addedFiles = [] }

update : Msg -> Model -> Model
update msg model =
    case msg of
      SetPlaylistName newContent ->
        { model | playlistListTitle = newContent }

      AddToPlayList id ->
        { model | addedFiles = id :: model.addedFiles }

      RemoveFromPlaylist i ->
        { model | addedFiles =
          (List.take i model.addedFiles) ++ (List.drop (i+1) model.addedFiles) }


view : Model -> Html Msg
view model =
    div [  ]
        [ div [] [ h2 [] [ text "Edit playlist:" ]]
        , div [] [ text "Enter title: "
          , input [ onInput SetPlaylistName ] []
          ]
        , ol [] (List.map
          (\mentry -> li [] [ a [href mentry.filename] [ text mentry.name ], text " ", button [ onClick (AddToPlayList mentry.name) ] [ text "Add" ]])
          model.media)
        , div [] [ h2 [] [text (String.concat [ "Files added to playlist \"", model.playlistListTitle, "\":"] )]]
        , ol [] (List.map
          (\(songIndex, songName) -> li [] [ text songName, text " ", button [ onClick (RemoveFromPlaylist songIndex) ] [ text "Remove" ]])
          (toIndexedList (fromList model.addedFiles)))
        , button [] [ text "Save Changes" ]
        ]

main : Program Never Model Msg
main =
    beginnerProgram
      { model = initialModel
      , view = view
      , update = update
      }
