# Release Strategy

## How version changes work

On every commit to main, the version is auto incremented by the bump version github action.
The version is determined (with gitversion) by the last tag on main and the previous commits.

## Release Strategy

Features are developed on feature branches and merged into main.

Once one or multiple features are ready on main, the `release internal` workflow is triggered manually.
- This workflow builds the app and publishes it to the playstore dev branch.
- It also creates a tag on main and a pre-release on github.

(TODO: ci publish to playstore main branch)\
To publish the app to the playstore main branch, a manual change in the play store console is required.
- The pre-release on github is changed to a release.
