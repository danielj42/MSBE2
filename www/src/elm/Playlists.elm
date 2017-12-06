module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

type Msg
    = SetPlaylistName String

type alias Model =
  { playlists : List String, user: String}

initialModel : Model
initialModel =
  { playlists = [ "Fun playlist", "Awesome playlist", "Another playlist"], user = "Daniel" }

update : Msg -> Model -> Model
update msg model =
    case msg of
      SetPlaylistName newContent ->
        { model | user = newContent }


view : Model -> Html Msg
view model =
    div [  ]
        [ div [] [ a [href ""] [ text "Profile" ]]
        , div [] [ a [href ""] [ text "New Playlist" ]]
        , h3 [] [ text "Browse media:" ]
        , ul [] [ li [] [ a [href ""] [ text "Audio" ]]
          --, li [] [ a [href ""] [ text "Video" ]]
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
            (\listname -> li [] [ a [href ""] [ text (String.concat [listname, " "]) ] ])
            model.playlists)
        ]

main : Program Never Model Msg
main =
    beginnerProgram
      { model = initialModel
      , view = view
      , update = update
      }
