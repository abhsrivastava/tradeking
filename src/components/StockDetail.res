@react.component
let make = (~symbol) => {
  let (chartData, setChartData) = React.useState(() => [])
  let (duration, setDuration) = React.useState(() => Candles.ONE_DAY)
  let getChartData = () => {
    open Js.Promise2
    Candles.getCandleForSymbol(symbol, duration, 0)
    -> then (response => response.timeStamps -> Belt.Array.zip(response.closePrices) -> resolve)
    -> then(recordArray => setChartData(_ => recordArray) -> resolve)
  }

  React.useEffect1(() => {
    getChartData()
    -> ignore
    None
  }, [duration])

  if (chartData -> Js.Array.length > 0) {
    <div>
      <StockChart symbol chartData duration setDuration />
    </div>
  } else {
    <div style={{width: "100%"}}>
      <div style={{width: "50%", margin: "auto auto"}} className="h1">{"Loading..." -> React.string}</div>
    </div>
  }
}