/* global document */

import React from "react"
import { AppContainer } from "react-hot-loader"
import { render } from "react-dom"
import ReactOnRails from "react-on-rails"
import Base from "components/Base"

const consoleErrorReporter = ({ error }) => {
  console.error(error) // eslint-disable-line
  return null
}
consoleErrorReporter.propTypes = {
  error: React.PropTypes.instanceOf(Error).isRequired
}

const App = (props, railsContext, domNodeId) => {
  const renderApp = (Component) => {
    const element = (
      <AppContainer errorReporter={consoleErrorReporter}>
        <Component />
      </AppContainer>
    )
    render(element, document.getElementById(domNodeId))
  }
  renderApp(Base)
  if (module.hot) {
    module.hot.accept(["components/Base"], () => {
      renderApp(Base)
    })
  }
}

ReactOnRails.register({ App })
