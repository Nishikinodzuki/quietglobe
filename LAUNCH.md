# QuietGlobe release checklist

## Homebrew

- [ ] Create public `Nishikinodzuki/homebrew-tap` with `Casks/quietglobe.rb`.
- [ ] Publish a GitHub Release with the signed `QuietGlobe-1.0.0.zip`.
- [ ] Verify:
  ```bash
  brew install Nishikinodzuki/tap/quietglobe
  ```
- [ ] After notarization, submit a PR to `Homebrew/homebrew-cask`.

## Post-release

- [ ] Publish release notes.
- [ ] Add new FAQ entries based on real questions.
