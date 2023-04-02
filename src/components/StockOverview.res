@react.component
let make = (~quotes, ~addToWatchList, ~removeFromWatchList) => {
  <div>
    <AutoComplete addToWatchList />
    <StockList quotes removeFromWatchList />
  </div>
}