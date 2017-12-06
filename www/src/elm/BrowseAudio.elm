module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

type Msg
    = AddToPlayList String

type alias Model =
  { media : List MediaEntry, playlistTitle : String }

type alias MediaEntry =
  { name : String, filename : String }

initialModel : Model
initialModel =
  { media = [{ name = "Debussy - Clair de Lune", filename = "debussy-clair-de-lune.mp3" }, { name = "Bach - Toccata and Fugue", filename = "Toccata-and-Fugue-Dm.mp3" }, { name = "Beethoven - Für Elise", filename = "fur-elise.mp3" }]
  , playlistTitle = "My Playlist" }

update : Msg -> Model -> Model
update msg model =
    case msg of
      AddToPlayList newContent ->
        { model | playlistTitle = newContent }


view : Model -> Html Msg
view model =
    div [  ]
        [ div [] [ h2 [] [ text "Browse Audio files" ]]
        , ol [] (List.map
          (\mentry -> li [] [ a [href mentry.filename] [ text mentry.name ], text " ", button [] [ text "Play"]])
          model.media)
        , button [] [ text "New playlist"]
        ]

main : Program Never Model Msg
main =
    beginnerProgram
      { model = initialModel
      , view = view
      , update = update
      }
