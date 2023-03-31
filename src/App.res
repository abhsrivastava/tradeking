%%raw("import './styles/App.css'")

@react.component
let make = () => {
  <div className="mt-5">{"hello world" -> React.string}</div>
}