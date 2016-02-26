module SearchBar.Update where

import Effects exposing (Effects, Never)
import SearchBar.Model exposing (Model)
import SearchBar.Effects exposing (searchProducts, goToSearch, delayHidding)
import SearchBar.Actions exposing (..)
import Html.Animation as UI
import Html.Animation.Properties exposing (..)
import Maybe
import String
import Time exposing (second)

-- UPDATE

onMenu =
  UI.forwardTo
      Animate
      .showStyle
      (\w style -> { w | showStyle = style })

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp -> ( model, Effects.none )

    NavigateToSearch que ->
      if String.isEmpty que then
        ( model
        , Effects.none
        )
      else
        ( model
        , goToSearch que
        )

    SearchResults products ->
      let (newSeeking, waitingQuery) = model.waiting

          newProducts = Maybe.withDefault [] products

          newEffects =
            if newSeeking then
              searchProducts waitingQuery
            else
              Effects.none
      in
      ( { model | products = newProducts
        , seeking = newSeeking
        , waiting = (False, "")
        }
      , newEffects
      )

    ShowBar ->
      UI.animate
          |> UI.duration (0.5*second)
          |> UI.props
             [ Opacity (UI.to 1)
             , RotateX (UI.to 0) Deg
             , Display Block
             ]
          |> onMenu ( model )

    Animate subAction ->
      onMenu model subAction

    DelayHidding ->
      ( model , delayHidding ()
      )

    HideBar ->
      UI.animate
          |> UI.delay (0.4*second)
          |> UI.duration (0.5*second)
          |> UI.props
             [ Opacity (UI.to 0)
             , RotateX (UI.to 90) Deg
             ]
          |> UI.andThen
          |> UI.props
             [  Display None
             ]
          |> onMenu (model)

    RequestProducts term ->
      if String.isEmpty term then
        ( { model | query = term
          , products = []
          }
          , Effects.none
        )
      else if model.seeking == True then
        ( { model | waiting = (True, term)
          , query = term
          }
        , Effects.none
        )
      else
        ( { model | seeking = True
          , query = term
          }
        , searchProducts term
        )
