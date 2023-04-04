type chart = {
  id: string
}
type xaxis = {
  categories: array<int>
}
type options = {
  chart: chart,
  xaxis: xaxis
}
type series = {
  name: string,
  data: array<int>
}

module Chart = {    
    @module("react-apexcharts") @react.component external make: (~options: options, ~series: array<series>, ~type_: string, ~width: string, ~height: string) => React.element = "Chart"
}