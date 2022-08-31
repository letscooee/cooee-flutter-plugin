# Release Flutter Plugin

## Pre-release for Flutter Plugin


1. Node.js should be installed (requires to run publish script).
2. Flutter should be configure on the device.
3. Git command-line tool

## Step-by-step guide to Release Flutter Plugin

1. Add `CHANGELOG` you want (no need to commit; Step 2 will commit it by itself).
2. Run `node publish.js patch|minor|major|<version>`.
3. Commit Changed files (Constant.java, Constants.swift, CHANGELOG.md, pubspec.yaml) and push to gitlab.
4. Create tag with same as new version and push it to gitlab.
5. That set! Other things will be done by CI/CD.

## node publish.js command

`node publish.js patch | minor | major | \<version\>`

1. `node publish.js` runs script which will publish iOS SDK.
2. It requires one argument.

   1. `patch`: It will publish iOS SDK with `patch` version.
   2. `minor`: It will publish iOS SDK with `minor` version.
   3. `major`: It will publish iOS SDK with `major` version.
   4. `<version>`: It will publish iOS SDK with `version` version.
      <br/>Version should be in valid format i.e. `1.0.0`
3. Script will check for valid number and update version in `CooeeSDK.podspec` & `Constant.swift`.
4. Then script will push code to main repository and will also push tag.
5. At last script will push code to cocoapods repository.
