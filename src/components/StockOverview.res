@react.component
let make = (~watchList, ~addToWatchList, ~removeFromWatchList) => {
  <div>
    <AutoComplete addToWatchList />
    <StockList watchList removeFromWatchList />
  </div>
}