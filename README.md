# React Starter

This repository is my starting place for building React applications.

I created it using [create-react-app](https://github.com/facebookincubator/create-react-app), then ejected
the `react-scripts` to enable e2e testing with [WebdriverIO](http://webdriver.io/), and have more control
over configuration.

## Changes from default `create-react-app` app

* e2e testing with WebdriverIO, Mocha, and Chai.
* `--run-once` option added to `scripts/test.js`.
* `scripts/start.js` runs the app on port `3001` when `NODE_ENV` is test.
* [enzyme](https://github.com/airbnb/enzyme) is configured to work with jest and is available for unit tests.
* Added [flow](https://flowtype.org/) and `flow-typed`, as well as a postinstall hook to re-run `flow-typed install`
  whenever new dependencies are installed.

## Using the starter

If you want eslint to work in your editor, either put the `node_modules/.bin` on your `$PATH`,
or install eslint and the eslint dependencies listed in the `package.json` globally.

* `yarn start` will start the application on port 3000 with HMR enabled.
* `yarn test` will run tests in `--watch` mode, only running tests related to files changed since your last commit.
* `yarn acceptance` will run the WebdriverIO acceptance test suite.
* `yarn flow` will run the flow type checker.
* `yarn lint` will lint the `src` and `acceptance` folders.
* `yarn shipit` should be run after you've made your commit(s) and before you push changes. It runs
  linting, type checking, acceptance tests, and unit tests.
