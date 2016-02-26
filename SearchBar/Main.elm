module SearchBar where

import Effects exposing (Effects, Never)
import SearchBar.View exposing (view)
import SearchBar.Model exposing (init)
import SearchBar.Update exposing (update)
import SearchBar.Effects exposing (searchPage)
import StartApp
import Signal
import Task

app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = []
    }


main =
  app.html


port runner : Signal (Task.Task Never ())
port runner =
  app.tasks

port navigateToSearchPage: Signal String
port navigateToSearchPage =
  searchPage.signal
