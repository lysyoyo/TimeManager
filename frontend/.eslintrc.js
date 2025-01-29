module.exports = {
  extends: [
    "plugin:prettier/recommended", // Intègre Prettier avec ESLint
  ],
  rules: {
    "prettier/prettier": [
      "error",
      {
        singleQuote: false, // Désactive la règle des guillemets simples
      },
    ],
  },
};
