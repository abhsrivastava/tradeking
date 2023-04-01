%%raw("import '../styles/App.css'")

@react.component
let make = () => {
  <div>
    <Header />
    {
      switch RescriptReactRouter.useUrl().path {
      | list{} => <StockOverview />
      | list{"detail", symbol} => <StockDetail symbol/>
      | _ => <PageNotFound />
      }
    }
    <Footer />
  </div>
}