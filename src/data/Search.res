open Util

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

let parseResponse = (json) => {
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
let getSearchResult = (input) => {
  open Js.Promise2
  open Fetch
  `${Env.apiUrl}/search?q=${input}&token=${Env.apiKey}`
  -> get 
  -> then (Response.json)
  -> then (json => json -> parseResponse -> resolve)
  -> then (response => removeJunk(response) -> resolve)
}