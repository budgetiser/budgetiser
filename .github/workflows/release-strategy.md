| ||
| |/ merge on main -> autoincrement version
| |
|/ merge on release -> release to playstore dev branch & create tag on main & create gh-pre-release
|
| manual gh release creation (change from prerelease) -> publish on playstore main branch
|

## Autoincrement

Autoincrement changes minor and patch version

- uses commit messages

For a major version bump

- commit a 'major-commit' to main

## Release

- Create release on gh
- create a tag with syntax 'v0.0.0'
