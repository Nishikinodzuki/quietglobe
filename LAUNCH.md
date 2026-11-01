# QuietGlobe release checklist

## Release

- [ ] Build the Universal 2 app with a stable signing identity.
- [ ] Create `QuietGlobe-<version>.zip`.
- [ ] Update `VERSION` and `SHA256` in `install.sh`.
- [ ] Publish a GitHub Release with the zip.
- [ ] Verify:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/Nishikinodzuki/quietglobe/main/install.sh | bash
  ```

## Post-release

- [ ] Publish release notes.
- [ ] Add new FAQ entries based on real questions.
