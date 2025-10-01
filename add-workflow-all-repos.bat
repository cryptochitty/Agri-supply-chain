@echo off
REM Folder where all your repos are stored
SET "BASE_DIR=C:\Users\Dell\Documents\MyProject\Repos"

REM Loop through each folder
FOR /D %%G IN ("%BASE_DIR%\*") DO (
    IF EXIST "%%G\package.json" (
        ECHO Adding workflow to %%G

        REM Create workflow folder
        mkdir "%%G\.github\workflows" 2>nul

        REM Write workflow file
        (
            ECHO name: Universal Node.js CI
            ECHO on:
            ECHO   push:
            ECHO     branches:
            ECHO       - main
            ECHO   pull_request:
            ECHO jobs:
            ECHO   build:
            ECHO     runs-on: ubuntu-latest
            ECHO     steps:
            ECHO       - name: Checkout repository
            ECHO         uses: actions/checkout@v3
            ECHO       - name: Set up Node.js
            ECHO         uses: actions/setup-node@v3
            ECHO         with:
            ECHO           node-version: "18"
            ECHO       - name: Detect package manager and install dependencies
            ECHO         run: ^
                if exist package-lock.json (echo npm detected && npm ci) ^
                if exist yarn.lock (echo Yarn detected && yarn install --immutable) ^
                if not exist package-lock.json if not exist yarn.lock (echo No lock file found && exit 1)
            ECHO       - name: Run tests
            ECHO         run: echo "Add test commands here if needed"
            ECHO       - name: Build project
            ECHO         run: echo "Add build commands here if needed"
        ) > "%%G\.github\workflows\universal-nodejs.yml"

        ECHO Workflow added for %%G
    ) ELSE (
        ECHO Skipping %%G (not a Node.js repo)
    )
)

ECHO All done!
pause
