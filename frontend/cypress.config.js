const { defineConfig } = require("cypress");

module.exports = defineConfig({
  // Commented out component configuration
  // component: {
  //   setupNodeEvents(on, config) {
  //     require('@cypress/code-coverage/task')(on, config);
  //     // tell Cypress to use .babelrc file
  //     // and instrument the specs files
  //     // only the extra application files will be instrumented
  //     // not the spec files themselves
  //     return config;
  //   },
  //   devServer: {
  //     framework: 'next',
  //     bundler: 'webpack',
  //   },
  //   video: false,
  //   specPattern: 'components/**/*.cy.{js,jsx,ts,tsx}',
  //   viewportWidth: 1920,
  //   viewportHeight: 1080,
  // },
  e2e: {
    setupNodeEvents(on, config) {
      require("@cypress/code-coverage/task")(on, config);
      // tell Cypress to use .babelrc file
      // and instrument the specs files
      // only the extra application files will be instrumented
      // not the spec files themselves
      return config;
    },
    baseUrl: "http://localhost:8080",
    video: false,
    specPattern: "cypress/e2e/**/*.cy.{js,jsx,ts,tsx}",
    viewportWidth: 1920,
    viewportHeight: 1080,
    defaultCommandTimeout: 2000,
  },

  component: {
    devServer: {
      framework: "vue-cli",
      bundler: "webpack",
    },
  },
});
