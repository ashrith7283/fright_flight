# release-packaging Specification

## Purpose
Defines what the Android release build must look like so it can be uploaded to Google Play for closed testing: correct identity, proper signing, protected output and the required policy documents.

## Requirements

### Requirement: App identity
The Android app SHALL use the application id `com.ashrith.frightflight` and the display name "Fright Flight" everywhere the user or Play sees a name, and SHALL NOT contain the `com.example` namespace.

#### Scenario: Installed app identity
- **WHEN** a release build is installed on a device
- **THEN** its package id is `com.ashrith.frightflight` and its launcher label reads "Fright Flight"

#### Scenario: App still launches after the rename
- **WHEN** the renamed app is started
- **THEN** it opens to the main menu in landscape exactly as before

### Requirement: Original launcher icon
The app SHALL ship an original adaptive launcher icon showing a plane in a sky, with legacy icons for older devices, and SHALL NOT use the default Flutter icon or third-party art.

#### Scenario: Icon replaced
- **WHEN** the app is installed
- **THEN** the launcher shows the Fright Flight icon, not the Flutter logo

#### Scenario: Adaptive icon masks cleanly
- **WHEN** the launcher applies a circular or squircle mask
- **THEN** the plane remains fully visible inside the mask

### Requirement: Release signing with an upload key
Release builds SHALL be signed with an upload keystore whose location and passwords come from an untracked local properties file. The keystore and properties file SHALL NOT be committed. When the properties file is absent, the build SHALL still complete using the debug key and print a warning that the result is not uploadable.

#### Scenario: Signed bundle
- **WHEN** the properties file and keystore are present and a release App Bundle is built
- **THEN** the bundle is signed with the upload key

#### Scenario: Secrets stay out of the repo
- **WHEN** the repository contents are inspected
- **THEN** no keystore file, password or `key.properties` is tracked, and git ignores them

#### Scenario: Missing key does not break development
- **WHEN** a release build is run without the properties file
- **THEN** it completes with the debug key and a visible warning

### Requirement: Protected release output
The release build SHALL have code shrinking enabled and SHALL be buildable as an obfuscated App Bundle with Dart symbol files written outside the tracked source tree.

#### Scenario: Obfuscated bundle with symbols
- **WHEN** the documented release command is run
- **THEN** it produces an App Bundle and a symbols directory that git ignores

#### Scenario: Shrunk release still plays
- **WHEN** the shrunk release build is installed and a run is played
- **THEN** menus, sound, haptics and saved best score behave as in a debug build

### Requirement: Minimal release permissions
The release build SHALL declare no permissions beyond those the shipped features need, and SHALL NOT request network access while the game has no online features.

#### Scenario: No network permission
- **WHEN** the merged release manifest is inspected
- **THEN** it contains no INTERNET permission

### Requirement: Privacy policy and asset record
The repository SHALL contain a privacy policy matching the app's actual data handling (no personal data collected or sent off device; only the best score and settings stored locally) in a form that can be published at a public URL, and an `ASSETS.md` listing the origin and license of every art and audio asset.

#### Scenario: Policy matches behaviour
- **WHEN** the policy is read
- **THEN** it states that no personal data is collected or shared and that the best score and settings stay on the device

#### Scenario: Every asset is accounted for
- **WHEN** `ASSETS.md` is compared with the files under `assets/`
- **THEN** each file has a recorded source and license
