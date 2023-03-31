%%raw("import ('bootstrap/dist/css/bootstrap.min.css')")
switch ReactDOM.querySelector("#main") {
  | Some(rootElement) =>
    ReactDOM.Client.Root.render(
      rootElement -> ReactDOM.Client.createRoot,
      <React.StrictMode>
        <App />
      </React.StrictMode>
    )
  | _ => failwith("could not find the main element")
}