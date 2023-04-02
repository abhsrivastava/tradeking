open Util

type quote = {
  symbol: string,
  current: float,
  change: float,
  percentChange: float,
  dayHigh: float,
  dayLow: float,
  dayOpen: float,
  previousClosePrice: float
}
let parseResponse = (json, symbol) => {
  symbol,
  current: json -> getFloat("c"),
  change: json -> getFloat("d"),
  percentChange: json -> getFloat("dp"),
  dayHigh: json -> getFloat("h"),
  dayLow: json -> getFloat("l"),
  dayOpen: json -> getFloat("o"),
  previousClosePrice: json -> getFloat("pc")
}
let getQuoteForSymbol = (symbol) => {
  open Js.Promise2
  open Fetch
  `${Env.apiUrl}/quote?symbol=${symbol}&token=${Env.apiKey}`
  -> get
  -> then (Response.json)
  -> then (json => json -> parseResponse(symbol) -> resolve)
}