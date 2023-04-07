@react.component
let make = (~symbol) => {
  let (chartData, setChartData) = React.useState(() => [])
  let (duration, setDuration) = React.useState(() => Candles.ONE_DAY)
  React.useEffect1(() => {
    open Js.Promise2
    Candles.getCandleForSymbol(symbol, duration)
    -> then (response => response.timeStamps -> Belt.Array.zip(response.closePrices) -> resolve)
    -> then(recordArray => setChartData(_ => recordArray) -> resolve) 
    -> ignore
    None
  }, [duration])
  if (chartData -> Js.Array.length > 0) {
    <div>
      <StockChart symbol chartData setDuration />
    </div>
  } else {
    <div style={{width: "100%"}}>
      <div style={{width: "50%", margin: "auto auto"}} className="h1">{"Loading..." -> React.string}</div>
    </div>
  }
}