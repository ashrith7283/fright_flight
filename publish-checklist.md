# Publish checklist — Fright Flight v1.0.0+1

Code, tests, signing, privacy policy page and device checks are done. What remains is
below, in order. See [`docs/release.md`](docs/release.md) for build commands.

## Before the first upload
- [ ] Back up the upload keystore (`~/keys/fright-flight-upload.jks`) and its passwords
      somewhere off this Mac (password manager or encrypted cloud storage)
- [ ] Copy `build-symbols/` for this build outside the repo, labelled `1.0.0+1`
- [ ] Optional: fast-forward `main` to `dev`

## Play Console (starts the 14-day clock)
- [ ] Check the name "Fright Flight" is available, then create the app (free, game)
- [ ] App content:
  - [ ] Privacy policy: https://ashrith7283.github.io/fright_flight/privacy-policy
  - [ ] Ads: No
  - [ ] Data safety: no data collected or shared
  - [ ] Content rating questionnaire
  - [ ] Target audience
- [ ] Testing → Closed testing: upload
      `build/app/outputs/bundle/release/app-release.aab` and add 12+ testers
- [ ] Keep the closed test running for 14 continuous days

## During the 14-day wait
- [ ] Store listing assets:
  - [ ] 512×512 icon
  - [ ] 1024×500 feature graphic
  - [ ] At least 2 phone screenshots (landscape)
  - [ ] Short description (max 80 characters)
  - [ ] Full description
- [ ] Optional: replace the template `description` in `pubspec.yaml` and the template
      `README.md`

## After the 14 days
- [ ] Apply for production access
- [ ] `release-final`: roll out to production (same bundle, or a new build with a higher
      `+N` version in `pubspec.yaml`)
