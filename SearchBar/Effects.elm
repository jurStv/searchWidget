module SearchBar.Effects where

import Effects exposing (Effects, Never)
import SearchBar.Model exposing (Product)
import SearchBar.Actions exposing (..)
import Http
import Json.Decode as Json
import Task
import Signal


-- EFFECTS

delayHidding : () -> Effects Action
delayHidding _ =
  Task.sleep 500 `Task.andThen` (\_ -> Task.succeed 1)
    |> Task.map (\_ -> HideBar)
    |> Effects.task

searchProducts : String -> Effects Action
searchProducts query =
  Http.get decodeUrl (searchUrl query)
    |> Task.toMaybe
    |> Task.map SearchResults
    |> Effects.task


searchUrl : String -> String
searchUrl term =
  Http.url ("http://localhost:8000/api/search/" ++ term) []


decodeUrl : Json.Decoder (List Product)
decodeUrl =
  Json.at ["products"] (Json.list
    (Json.object3 Product
      (Json.at ["href"] Json.string)
      (Json.at ["img"] Json.string)
      (Json.at ["title"] Json.string)
    )
  )

goToSearch : String -> Effects Action
goToSearch term =
  Signal.send searchPage.address term
    |> Task.toMaybe
    |> Task.map (\_ -> NoOp)
    |> Effects.task

searchPage : Signal.Mailbox String
searchPage =
  Signal.mailbox ""
