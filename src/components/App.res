%%raw("import '../styles/App.css'")

@react.component
let make = () => {
  let (watchList, setWatchList) = React.useState(() => ["GOOG", "AAPL", "MSFT", "AMZN"])
  let (quotes, setQuotes) = React.useState(() => [])
  let addToWatchList = (symbol) => {
    setWatchList((wl: array<string>) => wl -> Belt.Array.keep(s => symbol != s) -> Belt.Array.concat([symbol]))
  }
  // let removeFromWatchList = (symbol) => {
  //   setWatchList((wl: array<string>) => wl -> Belt.Array.keep(s => symbol != s))
  // }

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
      | list{} => <StockOverview quotes addToWatchList />
      | list{"detail", symbol} => <StockDetail symbol />
      | _ => <PageNotFound />
      }
    }
  </div>
}