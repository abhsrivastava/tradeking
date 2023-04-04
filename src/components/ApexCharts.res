type stroke = {
  curve: string,
  width: int
}
type zoom = {
  enabled: bool
}
type dataLabels = {
  enabled: bool
}
type title = {
  text: string,
  align: string
}
type xaxis = {
  @as("type") xAxisType: string
}
type yaxis = {
  opposite: bool
}
type legend = {
  horizontalAlign: string
}
type chart = {
  @as("type") chartType: string,
  height: int,
  zoom: zoom
}

type series = {
  name: string,
  data: array<float>
}

type options = {
  chart: chart,
  dataLabels: dataLabels,
  stroke: stroke,
  title: title,
  subtitle: title,
  labels: array<int>,
  xaxis: xaxis,
  yaxis: yaxis,
  legend: legend
}

module Chart = {    
    @module("react-apexcharts") @react.component external make: (~options: options, ~series: array<series>, ~type_: string, ~width: string, ~height: string) => React.element = "Chart"
}
