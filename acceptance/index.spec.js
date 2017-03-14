/* eslint-env mocha */
/* eslint-disable func-names, prefer-arrow-callback, no-unused-expressions */
/* global browser, expect */

describe('Dynamic Lab', function () {
  it('should dynamically fill in variable placeholders when form is submitted', function () {
    browser.url('/');
    browser.click('=LAB');

    let body = browser.getText('div.doc-main');
    expect(body).to.contain('{{ projectId }}');
    expect(body).to.contain('curl api.{{ envName }}.{{ domainName }}');

    browser.click('=CONFIGURE LAB VARIABLES');

    browser.setValue('input.form-control[name=projectId]', 'project123');
    browser.setValue('input.form-control[name=envName]', 'awesomeland');
    browser.setValue('input.form-control[name=domainName]', 'example.com');

    browser.click('=SAVE');

    body = browser.getText('div.doc-main');
    expect(body).to.contain('project123');
    expect(body).to.contain('curl api.awesomeland.example.com');
  });
});

