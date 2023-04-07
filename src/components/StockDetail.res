@react.component
let make = (~symbol) => {
  let (chartData, setChartData) = React.useState(() => [])
  React.useEffect0(() => {
    open Js.Promise2
    Candles.getCandleForSymbol(symbol, Candles.SIXTY_MINUTES)
    -> then (response => response.timeStamps -> Belt.Array.zip(response.closePrices) -> resolve)
    -> then(tupArray => tupArray -> Belt.Array.map(((x, y)) => (x -> Belt.Int.toFloat *. 1000.0, y)) -> resolve) // convert the tuple back into object and convert to milliseconds
    -> then(recordArray => setChartData(_ => recordArray) -> resolve) 
    -> ignore
    None
  })
  if (chartData -> Js.Array.length > 0) {
    <div>
      <StockChart symbol chartData />
    </div>
  } else {
    <div style={{width: "100%"}}>
      <div style={{width: "50%", margin: "auto auto"}} className="h1">{"Loading..." -> React.string}</div>
    </div>
  }
}