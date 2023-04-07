type enabled = {
  enabled: bool
}
type animations = {
  speed: int
}
type chart = {
  @as("type") chartType: string,
  height: int,
  width: int,
  zoom: enabled,
  animations: animations
}

type datetimeUTC = {
  datetimeUTC : bool
}
type tooltipFormat = {
  format: string
}
type tooltip = {
  x: tooltipFormat
}

type xaxis = {
  @as("type") axisType: string,
  labels: datetimeUTC
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
  labels: array<float>,
  xaxis: xaxis,
  tooltip: tooltip,
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