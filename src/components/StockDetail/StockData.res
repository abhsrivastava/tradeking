@react.component
let make = (~symbol) => {
  let (profileInfo, setProfileInfo) = React.useState(() => None)
  React.useEffect0(() => {
    open Js.Promise2
    CompanyProfile.getCompanyProfile(symbol)->then(profile => setProfileInfo(_ => profile) -> resolve) -> ignore
    None
  })
  switch profileInfo {
  | None => <div />
  | Some(profileInfo) => {
    <div className="row border bg-white rounded shadow-sm p-4 mt-5">
      <div className="col">
        <div>
          <span className="fw-bold">
            {"Name:" -> React.string}
          </span>
          {profileInfo.name -> React.string}
        </div>
        <div>
          <span className="fw-bold">
          {"Country:" -> React.string}
          </span>
          {profileInfo.country -> React.string}
        </div>
        <div>
          <span className="fw-bold">
            {"Symbol: " -> React.string}
          </span>
          {profileInfo.symbol -> React.string}
        </div>
      </div>
      <div className="col">
        <div>
          <span className="fw-bold">
            {"Exchange: " -> React.string}
          </span>
          {profileInfo.exchange -> React.string}
        </div>
        <div>
          <span className="fw-bold">
            {"Industry: " -> React.string}
          </span>
          {profileInfo.industry -> React.string}
        </div>
        <div>
          <span className="fw-bold">
            {"IPO Date:" -> React.string}
          </span>
          {profileInfo.ipoDate -> React.string}
        </div>
      </div>
      <div className="col">
        <div>
          <span className="fw-bold">
            {"Market Cap:" -> React.string}
          </span>
          {profileInfo.marketCap -> Belt.Float.toString -> React.string}
        </div>
        <div>
          <span className="fw-bold">
            {"Url: " -> React.string}
          </span>
          <a href={profileInfo.companyUrl} target="_blank">{profileInfo.companyUrl -> React.string}</a>
        </div>
        <div>
          <span className="fw-bold">
            {"Logo:" -> React.string}
          </span>
          <img src={profileInfo.logo} style={{width: "50px"}}/>
        </div>
      </div>
    </div>
  }
  }
}