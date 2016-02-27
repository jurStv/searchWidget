module SearchBar.View where

import SearchBar.Model exposing (Product, Model)
import SearchBar.Actions exposing (..)
import Json.Decode as Json
import Signal
import String
import Html exposing (..)
import Html.Attributes exposing (src, class, style, href, placeholder, value, title)
import Html.Events exposing (..)
import Html.Animation as UI

-- VIEW

(=>) = (,)

view : Signal.Address Action -> Model -> Html
view address model =
  let searchProductBlock =
    if model.seeking then
      div [class "searchProduct" , style (List.append mainBlockStyle (UI.render model.showStyle)) ]
        [
          div [style ["text-align" => "center"]]
              [img [  src "/static/medAid/img/waiting2.gif"
                      , style [ "width" => "50px"
                                , "height" => "50px"
                                ]
                      ] []]
        ]
    else if (List.length model.products) == 0 then
      div [class "searchProduct" , style (List.append mainBlockStyle (UI.render model.showStyle)) ]
        [div []
          [ p [noProductsMessageStyle] [ textMessage model.query ]
          ]
        ]
    else
      div [class "searchProduct" , style (List.append mainBlockStyle (UI.render model.showStyle)) ]
        (List.map (productView address model) model.products)
  in
    div [ class "menu__searchBar" ]
      [ label [class "searchBar__icon"] [i [] []]
      , input
          [ class "searchBar__input"
          , value model.query
          , placeholder "Поиск"
          , onEnter address (NavigateToSearch model.query)
          , onFocus address ShowBar
          , onBlur address HideBar
          , on "input" targetValue (Signal.message address << RequestProducts)
          ] []
      , a [ onClick address (NavigateToSearch model.query)
          , href "#"
          , class "searchBar__button"
          , style [ "border-radius" => "0 2px 2px 0"
                  ,  "text-align" => "center"
                  ,  "padding-top" => "2px"
                  ]
          ] [ text "Найти" ]
      , searchProductBlock
      ]

textMessage : String -> Html
textMessage term =
  if String.isEmpty term then
    text "Начните печатать"
  else
    text "Товаров нет"

productView : Signal.Address Action -> Model -> Product -> Html
productView adress model product =
  let productText =
    if String.length product.title > 18 then
      (String.left 18 product.title) ++ "..."
    else
      product.title
  in
    div [style ["border-bottom" => "1px dotted gray"]]
      [ div [ productImageStyle product.img ] []
      , div [style ["height" => "50px", "padding-top" => "15px"]]
          [a [href product.href
            , title product.title] [text productText]]
      ]

productImageStyle : String -> Attribute
productImageStyle url =
  style
    [ "background" => ("url('" ++ url ++ "')")
    , "width" => "50px"
    , "height" => "50px"
    , "float" => "left"
    , "margin-right" => "8px"
    , "margin-left" => "3px"
    , "background-size" => "contain"
    , "background-position" => "center center"
    , "background-repeat" => "no-repeat"
    ]

noProductsMessageStyle : Attribute
noProductsMessageStyle =
  style
    [ "display" => "block"
    , "padding" => "8px 15px"
    , "text-transform" => "uppercase"
    , "color" => "darkgreen"
    , "text-align" => "center"
    ]

mainBlockStyle : List ( String, String )
mainBlockStyle = [ "border-radius" => "5px"
    , "overflow" => "hidden"
    , "width" => "270px"
    , "position" => "absolute"
    , "background" => "#fff"
    , "top" => "50px"
    , "left" => "0"
    ]



onEnter : Signal.Address a -> a -> Attribute
onEnter address value =
    on "keydown"
        (Json.customDecoder keyCode is13)
        (\_ -> Signal.message address value)


is13 : Int -> Result String ()
is13 code =
    if code == 13 then
        Ok ()

    else
        Err "not the right key code"
