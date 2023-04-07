%%raw("import '../styles/App.css'")

let parseLocalStorage = (str: string, default) => {
  open Js.Json
  switch str -> parseExn -> classify {
  | JSONArray(array) => array -> Js.Array2.map(item => item -> Js.Json.decodeString -> Belt.Option.getExn)
  | _ => default
  }
}
let writeToLocalStorage = (watchList) => {
  Dom.Storage2.localStorage -> Dom.Storage2.setItem("watchlist", watchList -> Js.Json.stringifyAny -> Belt.Option.getExn)
}
@react.component
let make = () => {
  let (watchList, setWatchList) = React.useState(() => {
    let default = ["GOOG", "AAPL", "MSFT", "AMZN"]
    open Dom.Storage2
    switch localStorage -> getItem("watchlist") {
    | Some(str) => {
      parseLocalStorage(str, default)
    }
    | None => default
    }
    
  })
  let (quotes, setQuotes) = React.useState(() => [])
  let addToWatchList = (symbol) => {
    let newWl = watchList -> Belt.Array.keep(s => symbol != s) -> Belt.Array.concat([symbol])
    setWatchList(_ => newWl)
    writeToLocalStorage(newWl)
  }
  let removeFromWatchList = (symbol) => {
    let newWl = watchList -> Belt.Array.keep(s => symbol != s)
    setWatchList(_ => newWl)
    writeToLocalStorage(newWl)
  }

  React.useEffect1(() => {
    open Js.Promise2
    watchList 
    -> Belt.Array.map(symbol => Quote.getQuoteForSymbol(symbol)) 
    -> all 
    -> then (quoteList => setQuotes(_ => quoteList) -> resolve)
    -> ignore
    None
  }, [watchList])

  <div className="container">
    <Header />
    {
      switch RescriptReactRouter.useUrl().path {
      | list{} => <StockOverview quotes addToWatchList removeFromWatchList />
      | list{"detail", symbol} => <StockDetail symbol />
      | _ => <PageNotFound />
      }
    }
  </div>
}