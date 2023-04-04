@react.component
let make = (~quotes, ~addToWatchList) => {
  <div>
    <AutoComplete addToWatchList />
    <StockList quotes />
  </div>
}