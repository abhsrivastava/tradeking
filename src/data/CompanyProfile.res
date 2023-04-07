open Fetch
open Js.Promise2
open Util
open Js.Json

type profile = {
  country: string,
  currency: string,
  exchange: string, 
  industry: string,
  ipoDate: string,
  logo: string,
  marketCap: float,
  name: string,
  symbol: string,
  companyUrl: string
}
let parseProfile = (json: Js.Json.t) : option<profile> => {
  switch json -> classify {
  | JSONObject(obj) => 
    if (obj -> Js.Dict.keys -> Js.Array.length > 0) {
      Some(
        {
          country: json -> getString("country"),
          currency: json -> getString("currency"),
          exchange: json -> getString("exchange"),
          industry: json -> getString("finnhubIndustry"),
          ipoDate: json -> getString("ipo"),
          logo: json -> getString("logo"),
          marketCap: json -> getFloat("marketCapitalization"),
          name: json -> getString("name"),
          symbol: json -> getString("ticker"),
          companyUrl: json -> getString("weburl")
        })
    } else {
      None
    }
   | _ => None
  }
}

let getCompanyProfile = (symbol: string) : promise<option<profile>> => {
  `${Env.apiUrl}/stock/profile2?symbol=${symbol}&token=${Env.apiKey}`
  -> get
  -> then(Response.json)
  -> then(json => parseProfile(json) -> resolve)
}