# Release workflow

This document outlines how to release a new budgetiser version and the developer workflow.

## How to release a new feature
- Implement a feature in a feature branch.
- Create a Pull-request to `main`
   - After the merge a new version will be automatically applied
- Create a Pull-request to `release`
   - After the merge the new version will be released to the play-store internal-release-branch
   - Manually create a tag on main (broken ci)
   - Manually create a gh pre-release (broken ci)
- Manually upgrade the playstore release to a production release in the play-console (broken ci)
   - Manually change the gh pre-release to a full release (broken ci: this should be the ci trigger)
