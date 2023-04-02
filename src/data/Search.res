open Fetch
open Js.Json
open Belt.Option

type stock = {
  description: string,
  displaySymbol: string,
  symbol: string, 
  stockType: string
}

type searchResponse = {
  count: int,
  result: array<stock>
}

let getValue = (json: t, key: string, fn: (t) => option<'a>) : option<'a> => {
  switch json -> classify {
  | JSONObject(obj) => 
    switch obj -> Js.Dict.get(key) {
    | Some(valueObj) => valueObj -> fn
    | None => None
    }
  | _ => None
  }
}

let getString = (json: t, key: string) : string => {
  json -> getValue(key, decodeString) -> getExn
}

let getInt = (json: t, key: string): int => {
  json -> getValue(key, decodeNumber) -> map(Belt.Int.fromFloat) -> getExn
}

let getArray = (json: t, key: string): array<t> => {
  json -> getValue(key, decodeArray) -> getExn
}

let parseResponse = (json: t) : searchResponse => {
  {
    count: json -> getInt("count"), 
    result: 
      json 
      -> getArray("result") 
      -> Belt.Array.map(itemJson => {
          description: itemJson -> getString("description"), 
          displaySymbol: itemJson -> getString("displaySymbol"), 
          symbol: itemJson -> getString("symbol"), 
          stockType: itemJson -> getString("type")})
  }
}

let removeJunk = (response) => {
  let newResult = response.result -> Belt.Array.keep(result => {
    result.symbol -> Js.String2.indexOf(".") == -1
  })
  {
    count: newResult -> Belt.Array.length,
    result: newResult
  }
}
let getSearchResult = (input: string) : promise<searchResponse> => {
  open Js.Promise2
  `${Env.apiUrl}/search?q=${input}&token=${Env.apiKey}`
  -> get 
  -> then (Response.json)
  -> then (json => json -> parseResponse -> resolve)
  -> then (response => removeJunk(response) -> resolve)
}