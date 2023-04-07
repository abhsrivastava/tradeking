open Util

type candleResponseStatus = OK | NO_DATA
let one_day = 24. *. 60. *. 60. *. 1000.

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
  timeStamps: array<float>,
  volumes: array<int>
}

type duration = 
| ONE_DAY
| ONE_WEEK
| ONE_MONTH
| ONE_YEAR
| FIVE_YEARS

let getResolutionString = (duration: duration) => {
  switch duration {
  | ONE_DAY => "5"
  | ONE_WEEK => "60"
  | ONE_MONTH => "D"
  | ONE_YEAR => "W"
  | FIVE_YEARS => "M"
  }
}

let parseResponse = (json, symbol) : option<candleResponse> => 
  switch json -> getString("s") -> fromStringCandleResponseStatus {
  | OK => Some({
      symbol: symbol,
      closePrices: json -> getFloatArray("c"),
      highPrices: json -> getFloatArray("h"),
      lowPrices: json -> getFloatArray("l"),
      openPrices: json -> getFloatArray("o"),
      status: json -> getString("s") -> fromStringCandleResponseStatus,
      timeStamps: json -> getFloatArray("t") -> Belt.Array.map(f => f *. 1000.), // convert it back to millisecond epoch
      volumes: json -> getIntArray("v")
  })
  | NO_DATA => None
  }

let calculateToDate = () => {
  let now = Js.Date.now()
  let today = now -> Js.Date.fromFloat
  let lastWeekday = switch today -> Js.Date.getDay -> Belt.Int.fromFloat {
    | 6 => now -. one_day // saturday
    | 1 => now -. (2.0 *. one_day) // sunday
    | _ => now
  } -> Js.Date.fromFloat
  Js.Date.makeWithYMDHMS(
    ~year = lastWeekday -> Js.Date.getFullYear, 
    ~month = lastWeekday -> Js.Date.getMonth, 
    ~date = lastWeekday -> Js.Date.getDate, 
    ~hours = 23.0, 
    ~minutes = 59.0, ~seconds = 59.0, 
    ()) -> Js.Date.getTime 
}

let calculateFromDate = (toDate: float, duration: duration) => {
  let durationInMs = switch duration {
  | ONE_DAY => one_day
  | ONE_WEEK => 7. *. one_day
  | ONE_MONTH => 30. *. one_day
  | ONE_YEAR => 365. *. one_day
  | FIVE_YEARS => 5. *. 365. *. one_day
  }
  toDate -. durationInMs
}

let rec getCandleForSymbol = (symbol: string, duration: duration, subtract: int) => {
  open Fetch
  open Js.Promise2
  let to = calculateToDate() -. (subtract -> Belt.Int.toFloat *. one_day)
  let from = calculateFromDate(to, duration)
  `${Env.apiUrl}/stock/candle?symbol=${symbol}&resolution=${getResolutionString(duration)}&from=${(from /. 1000.) -> Belt.Float.toString}&to=${(to /. 1000.) -> Belt.Float.toString}&token=${Env.apiKey}`
  -> get
  -> then (Response.json)
  -> then (json => {
    switch parseResponse(json, symbol) {
    | Some(resp) => resp -> resolve
    | None => getCandleForSymbol(symbol, duration, subtract + 1)
    }
  })
}