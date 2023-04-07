@react.component
let make = (~symbol, ~chartData, ~setDuration) => {
  open ApexCharts
  let options = {
    chart: {
      chartType: "area",
      height: 300,
      width: 300,
      zoom: {
        enabled: false
      },
      animations: {
        speed: 1300
      }
    },
    dataLabels: {
      enabled: true
    },
    stroke: {
      curve: "smooth"
    },

    title: {
      text: symbol,
      align: "left"
    },
    labels: chartData -> Belt.Array.map(((x, _)) => x),
    xaxis: {
      axisType: "datetime",
      labels: {
        datetimeUTC: false
      }
    },
    tooltip: {
      x: {
        format: "MMM dd HH:MM"
      }
    },
    yaxis: {
      opposite: true
    },
    legend: {
      horizontalAlign: "left"
    }
  }
  
  let series = [{
    name: `${symbol}`,
    data: chartData -> Belt.Array.map(((_, y)) => y)
  }]

  let handleClick = (duration, _) => {
    setDuration(_ => duration)
  }

  <div className="app">
    <div className="row">
      <div className="mixed-chart">
        <Chart options series />
      </div>
      <div>
        <button onClick={handleClick(Candles.ONE_DAY)}>{"24 Hours" -> React.string}</button>
        <button onClick={handleClick(Candles.ONE_WEEK)}>{"1 Week" -> React.string}</button>
        <button onClick={handleClick(Candles.ONE_MONTH)}>{"1 Month" -> React.string}</button>
        <button onClick={handleClick(Candles.ONE_YEAR)}>{"1 Year" -> React.string}</button>
        <button onClick={handleClick(Candles.FIVE_YEARS)}>{"5 Years" -> React.string}</button>
      </div>
    </div>
  </div>
}