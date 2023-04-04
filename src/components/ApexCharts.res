type enabled = {
  enabled: bool
}
type chart = {
  @as("type") chartType: string,
  height: int,
  width: int,
  zoom: enabled
}
type xaxis = {
  @as("type") axisType: string
}
type stroke = {
  curve: string
}
type title = {
  text: string,
  align: string
}
type yaxis = {
  opposite: bool
}
type legend = {
  horizontalAlign: string
}
type options = {
  chart: chart,
  dataLabels: enabled,
  stroke: stroke,
  title: title,
  subtitle: title,
  labels: array<int>,
  xaxis: xaxis,
  yaxis: yaxis,
  legend: legend
}
type series = {
  name: string,
  data: array<float>
}

module Chart = {    
  @module("react-apexcharts") @react.component external make: (~options: options, ~series: array<series>) => React.element = "default"
}