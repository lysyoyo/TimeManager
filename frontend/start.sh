#!/bin/bash

if [ "$NODE_ENV" = "development" ]; then
    echo "Starting in development mode with watch..."
    npm install
    npm run watch & npm run dev:android
else
    echo "Starting in production mode..."
    npx cap sync && cd android && ./gradlew assembleDebug
fi