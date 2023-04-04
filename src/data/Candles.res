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

let parseResponse = (json, symbol) : candleResponse => {
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
  let to = (Js.Date.now() /. 1000.0) -> Js.Math.floor_int
  let weekendFactor = switch Js.Date.make() -> Js.Date.getDay -> Belt.Int.fromFloat {
  | 6 => 2 // if its saturday return 2 days worth of data
  | 0 => 3 // if its sunday return 3 days worth of data
  | _ => 1 // any other day just return 24 hours worth of data
  }
  let from = switch res {
  | ONE_MINUTE
  | FIVE_MINUTES
  | FIFTEEN_MINUTES
  | THIRTY_MINUTES
  | SIXTY_MINUTES => to - (weekendFactor * 24 * 60 * 60) // 3 days ago
  | DAY => to - ((7 + weekendFactor) * 24 * 60 * 60) // one week ago
  | WEEK => to - 4 * 7 * 24 * 60 * 60 // 4 weeks ago
  | MONTH => to - 365 * 24 * 60 * 60 // 1 year ago
  }
  
  `${Env.apiUrl}/stock/candle?symbol=${symbol}&resolution=${getResolutionString(res)}&from=${from -> Belt.Int.toString}&to=${to -> Belt.Int.toString}&token=${Env.apiKey}`
  -> get
  -> then (Response.json)
  -> then (json => parseResponse(json, symbol) -> resolve)
}