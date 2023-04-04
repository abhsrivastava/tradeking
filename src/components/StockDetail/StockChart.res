@react.component
let make = (~symbol, ~chartData) => {
  open ApexCharts
  let options = {
    chart: {
      chartType: "area",
      height: 300,
      width: 300,
      zoom: {
        enabled: false
      }
    },
    dataLabels: {
      enabled: false
    },
    stroke: {
      curve: "straight"
    },

    title: {
      text: "Fundamental Analysis of Stocks",
      align: "left"
    },
    subtitle: {
      text: "Price Movements",
      align: "left"
    },
    labels: chartData -> Belt.Array.map(((x, _)) => x),
    xaxis: {
      axisType: "datetime",
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

  <div className="app">
    <div className="row">
      <div className="mixed-chart">
        <Chart options series />
      </div>
    </div>
  </div>
}