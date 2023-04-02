open ReactIcons

@react.component
let make = (~quotes : array<Quote.quote>, ~removeFromWatchList) => {
  let columns = ["Name", "Last", "Chg", "Chg%", "High", "Low", "Open", "Pclose"]
  let getTextColor = (val: float) : string => {
    if val < 0.0 {
      "text-danger"
    } else {
      "text-success"
    }
  }
  let getIcon = (val: float) => {
    if val < 0.0 {
      <BsCaretDownFill />
    } else {
      <BsCaretUpFill />
    }
  }
  <div>
    <table className="table hover mt-5 w-100">
      <thead style={{color: "rgb(79, 89, 102)"}}>
      <tr>
      {
        columns 
        -> Belt.Array.mapWithIndex((i, col) => 
          <th className="col" key={i -> Belt.Int.toString}>{col-> React.string}</th>) 
        -> React.array
      }
      </tr>
      </thead>
      <tbody>
      {
        quotes 
        -> Belt.Array.map(quote => 
          <tr className="table-row" key={quote.symbol}>
          <th className="row">{quote.symbol -> React.string}</th>
          <td>{quote.current -> Belt.Float.toString -> React.string}</td>
          <td className={getTextColor(quote.change)}>{quote.change -> Belt.Float.toString -> React.string}{getIcon(quote.change)}</td>
          <td className={getTextColor(quote.percentChange)}>{quote.percentChange -> Belt.Float.toString-> React.string}{getIcon(quote.percentChange)}</td>
          <td>{quote.dayHigh -> Belt.Float.toString -> React.string}</td>
          <td>{quote.dayLow -> Belt.Float.toString -> React.string}</td>
          <td>{quote.dayOpen -> Belt.Float.toString -> React.string}</td>
          <td>{quote.previousClosePrice -> Belt.Float.toString -> React.string}</td>
          </tr>)
        -> React.array
      }
      </tbody>
    </table>
  </div>
}