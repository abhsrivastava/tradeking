open Js.Json
open Util

type candleResponseStatus = OK | NO_DATA
let fromStringCandleResponseStatus = (status: string) => {
  switch status {
  | "ok" => OK
  | "no_data" => NO_DATA
  | _ => failwith("not a valid response in the status field. valid values are ok and no_data")
  }
}

type candleResponse = {
  symbol: string,
  closePrices: array<float>,
  highPrices: array<float>,
  lowPrices: array<float>,
  openPrices: array<float>,
  status: candleResponseStatus,
  timeStamps: array<int>,
  volumes: array<int>
}

type resolution = 
| ONE_MINUTE 
| FIVE_MINUTES 
| FIFTEEN_MINUTES 
| THIRTY_MINUTES 
| SIXTY_MINUTES 
| DAY 
| WEEK 
| MONTH

let getResolutionString = (resolution) => {
  switch resolution {
  | ONE_MINUTE => "1"
  | FIVE_MINUTES => "5"
  | FIFTEEN_MINUTES => "15"
  | THIRTY_MINUTES => "30"
  | SIXTY_MINUTES => "60"
  | DAY => "D"
  | WEEK => "W"
  | MONTH => "M"
  }
}

let parseResponse = (json, symbol) => {
  symbol: symbol,
  closePrices: json -> getFloatArray("c"),
  highPrices: json -> getFloatArray("h"),
  lowPrices: json -> getFloatArray("l"),
  openPrices: json -> getFloatArray("o"),
  status: json -> getString("s") -> fromStringCandleResponseStatus,
  timeStamps: json -> getIntArray("t"),
  volumes: json -> getIntArray("v")
}

let getCandleForSymbol = (symbol: string, res: resolution) => {
  open Fetch
  open Js.Promise2
  let dt = Js.Date.make()
  let to = (dt -> Js.Date.getTime /. 1000.0) -> Js.Math.floor_int
  let from = switch res {
  | ONE_MINUTE => to - 24 * 60 * 60 // 24 hours ago
  | FIVE_MINUTES =>  to - 24 * 60 * 60
  | FIFTEEN_MINUTES => to - 24 * 60 * 60
  | THIRTY_MINUTES => to - 24 * 60 * 60
  | SIXTY_MINUTES => to - 24 * 60 * 60
  | DAY => to - 7 * 24 * 60 * 60 // one week ago
  | WEEK => to - 4 * 7 * 24 * 60 * 60 // 4 weeks ago
  | MONTH => to - 52 * 7 * 24 * 60 * 60 // 52 weeks ago
  }
  
  `${Env.apiUrl}/stock/candle?symbol=${symbol}&resolution=${getResolutionString(res)}&from=${from -> Belt.Int.toString}&to=${to -> Belt.Int.toString}&token=${Env.apiKey}`
  -> get
  -> then (Response.json)
  -> then (json => parseResponse(json) -> resolve)
}