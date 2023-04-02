open Js.Promise2

@react.component
let make = (~addToWatchList) => {
  let (input, setInput) = React.useState(() => "")
  let (searchResult, setSearchResult) = React.useState(() => [])
  React.useEffect1(() => {
    if (input -> Js.String.length >= 1) {
      Search.getSearchResult(input) 
      -> then (response => setSearchResult(_ => response.result) -> resolve) 
      -> ignore
    } else {
      setSearchResult(_ => [])
    }
    None
  }, [input]) -> ignore

  let handleClick = (symbol, _) => {
    symbol -> addToWatchList -> ignore
    setSearchResult(_ => [])
    setInput(_ => "")
  }
  let handleChange = (event) => {
    let newText = ReactEvent.Form.currentTarget(event)["value"]
    setInput(_ => newText)
  }
  let renderDropDown = () => {
    if searchResult -> Belt.Array.length > 0 {
      "dropdown-menu w-75 autocomplete-search-result-list show"
    } else {
      "dropdown-menu"
    }
  }
  <div className="w-75 p-5 rounded mx-auto">
    <div className="form-floating dropdown">
      <input 
        className="autocomplete-form-input form-control " 
        id="search" 
        type_="text" 
        value={input} 
        placeholder="Search" 
        autoComplete="off" 
        onChange={handleChange} />

      <label htmlFor="search">{"Search" -> React.string}</label>
      <ul className={renderDropDown()}>
        {
        searchResult 
        -> Belt.Array.map(result => 
          <li key={result.symbol} onClick={result.symbol -> Js.String.toUpperCase -> handleClick}>
            <div>
              <div style={{display:"inline"}}>{`${result.description}` -> React.string}</div>
              <b>{`  (${result.symbol -> Js.String.toUpperCase})` -> React.string}</b>
            </div>
          </li>)
        -> React.array
        }
      </ul>
    </div>
  </div>
}