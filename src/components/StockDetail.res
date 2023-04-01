@react.component
let make = (~symbol: string) => {
  <div>{`stock detail ${symbol}` -> React.string}</div>
}