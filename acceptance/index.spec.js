/* global browser*/
describe('Homepage', function () {
  it('it should render the homepage without crashing', function () {
    browser.url('/');
    const header = browser.getText('.App-header');
    expect(header).to.contain('Welcome to React');

    const body = browser.getText('.App-intro');
    expect(body).to.contain('To get started, edit src/App.js and save to reload.');
  });
});

