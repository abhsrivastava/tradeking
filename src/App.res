%%raw("import './styles/App.css'")
module Env =  {
  @val @scope(("process", "env")) external email: string = "EMAIL"
  @val @scope(("process", "env")) external apiKey: string = "API_KEY"
}

@react.component
let make = () => {
  Js.Console.log(Env.email)
  Js.Console.log(Env.apiKey)
  <div className="mt-5">{"hello world" -> React.string}</div>
}