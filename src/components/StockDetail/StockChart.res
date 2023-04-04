@react.component
let make = (~symbol, ~chartData) => {
  open ApexCharts
  let options = {
    chart: {
      chartType: "area",
      height: 500,
      zoom: {
        enabled: false
      }},
      dataLabels: {
        enabled: false
      },
      stroke: {
        curve: "straight",
        width: 2
      },
      title: {
        text: `${symbol} chart`,
        align: "center"
      },
      subtitle: {
        text: "price movement",
        align: "left"
      },
      labels: chartData -> Belt.Array.map(((x, _)) => x),
      xaxis: {
        xAxisType: "datetime"
      },
      yaxis: {
        opposite: true
      },
      legend: {
        horizontalAlign: "left"
      }
    }
    let series = [{
      name: `${symbol} price history}`,
      data: chartData -> Belt.Array.map(((_, y)) => y)
    }]
  <div style={{backgroundColor: "rgba(145, 158, 171, 0.04)"}} className="mt-5 p-4 shadow-sm bg-white">
    <Chart options={options} series={series} type_="area" width="500px" height="500px" />
  </div>
}