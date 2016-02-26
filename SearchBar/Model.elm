module SearchBar.Model where

import Effects exposing (Effects, Never)
import Html.Animation as UI
import Html.Animation.Properties exposing (..)

-- MODEL

type alias Model =
  { products: List Product
  , seeking: Bool
  , query: String
  , waiting: (Bool, String)
  , showStyle : UI.Animation
  }

type alias Product =
  { href: String
  , img: String
  , title: String
  }

init : (Model, Effects a)
init =
    ( Model [] False "" (False, "")
                (UI.init [ RotateX 90 Deg
                  , Opacity 0.0
                  , Display None
                  ]
                )
    , Effects.none
    )
