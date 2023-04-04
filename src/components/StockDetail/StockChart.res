@react.component
let make = () => {
  open ApexCharts
  let options = {
    chart: {
      id: "basic-bar"
    },
  xaxis: {
    categories: [1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999]
  }}
  let series = [{
    name: "series-1",
      data: [30, 40, 45, 50, 49, 60, 70, 91]
  }]

  <div className="app">
    <div className="row">
      <div className="mixedChart">
        <Chart options series type_="bar" width="500px" height="500px" />
      </div>
    </div>
  </div>
}