%%raw("import '../styles/App.css'")

@react.component
let make = () => {
  let (watchList, setWatchList) = React.useState(() => [])
  let addToWatchList = (symbol) => {
    setWatchList((wl: array<string>) => wl -> Belt.Array.keep(s => symbol != s) -> Belt.Array.concat([symbol]))
  }
  let removeFromWatchList = (symbol) => {
    setWatchList((wl: array<string>) => wl -> Belt.Array.keep(s => symbol != s))
  }
  <div className="container">
    <Header />
    {
      switch RescriptReactRouter.useUrl().path {
      | list{} => <StockOverview watchList addToWatchList removeFromWatchList />
      | list{"detail", symbol} => <StockDetail symbol />
      | _ => <PageNotFound />
      }
    }
    <Footer />
  </div>
}