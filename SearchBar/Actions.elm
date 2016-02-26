module SearchBar.Actions where

import SearchBar.Model exposing (Product)
import Html.Animation as UI

type Action
  = NoOp
      | NavigateToSearch String
      | RequestProducts String
      | SearchResults (Maybe (List Product))
      | ShowBar
      | Animate UI.Action
      | HideBar
      | DelayHidding
