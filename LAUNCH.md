# QuietGlobe launch & SEO checklist

## 1. GitHub repository

- [ ] Create public repo `Nishikinodzuki/quietglobe`.
- [ ] Description: `Instant, HUD-free input source switching for macOS. Disable the ABC/Russian popup and Globe key HUD.`
- [ ] Website: `https://nishikinodzuki.github.io/quietglobe/`
- [ ] Topics:
  `macos`, `macos-app`, `swift`, `menubar`, `input-source`, `keyboard-layout`,
  `globe-key`, `language-switcher`, `accessibility`, `homebrew`, `hud`,
  `quietglobe`, `abc-russian`, `keyboard-layout-switcher`.
- [ ] Enable GitHub Pages: Settings → Pages → Deploy from a branch → `main` / `/docs`.
- [ ] Verify `robots.txt`, `sitemap.xml`, `/ru/`, and `llms.txt` are reachable.
- [ ] Add a social preview image in repo Settings → Social preview (`docs/assets/og-image.png`).

## 2. Search engines

- [ ] Google Search Console: add `https://nishikinodzuki.github.io/quietglobe/`.
- [ ] Verify with the HTML tag (add it to `docs/index.html`) or DNS.
- [ ] Submit `https://nishikinodzuki.github.io/quietglobe/sitemap.xml`.
- [ ] Request indexing for `/` and `/ru/`.
- [ ] Bing Webmaster Tools: add the site and submit the sitemap.
- [ ] Yandex Webmaster: add the site and submit the sitemap (important for RU).
- [ ] Check `site:nishikinodzuki.github.io/quietglobe` after a few days.
- [ ] Add the site to Google Search Console's “Enhancements” and fix any FAQ/structured-data warnings.

## 3. Content / keywords

Primary keywords:

- macOS input source indicator
- disable ABC/Russian popup macOS
- Globe key HUD
- language switcher popup macOS
- hide input source HUD
- macOS keyboard layout switcher
- ABC Russian popup remover

Russian keywords:

- убрать окно ABC/Russian на macOS
- индикатор раскладки macOS
- всплывающее окно при смене языка
- Globe key HUD
- переключение раскладки без окна
- macOS сменить язык без окна

Keep keywords in:

- `<title>` and `<meta name="description">`
- H1 and first paragraph
- image alt text
- FAQ questions and answers
- README first paragraph

## 4. Backlinks / launch posts

Post the same story with a link to the site:

- [ ] Reddit: r/macapps, r/macOS, r/apple, r/SwiftUI, r/homebrew
- [ ] Hacker News: “Show HN: QuietGlobe — remove the ABC/Russian popup on macOS”
- [ ] Product Hunt
- [ ] MacUpdate
- [ ] AlternativeTo
- [ ] Telegram channels about macOS and productivity
- [ ] Habr / VC.ru (Russian)
- [ ] X/Twitter, Threads, Mastodon
- [ ] Indie Hackers
- [ ] Lobsters

Do not spam. Post once per community, answer questions, and link to the GitHub repo and site.

## 5. Custom domain (recommended)

A custom domain improves trust and SEO. Example: `quietglobe.app`.

- [ ] Buy the domain.
- [ ] Add it in GitHub Pages → Custom domain.
- [ ] Create `docs/CNAME` with the domain (one line, no protocol).
- [ ] Add DNS records (`A`/`AAAA` for apex, `CNAME` for `www`).
- [ ] Update canonical URLs, `hreflang`, `sitemap.xml`, `robots.txt`, and the repo website field.
- [ ] Re-submit the sitemap in Google Search Console.

## 6. Homebrew

- [ ] Create `Nishikinodzuki/homebrew-quietglobe` with `Casks/quietglobe.rb`.
- [ ] Publish a GitHub Release with the signed `QuietGlobe-1.0.0.zip`.
- [ ] Verify:
  ```bash
  brew install --cask Nishikinodzuki/quietglobe/quietglobe
  ```
- [ ] After notarization, submit a PR to `Homebrew/homebrew-cask`.

## 7. Post-launch

- [ ] Add a “Star on GitHub” link to the site (already present).
- [ ] Add screenshots/GIFs to the README and site.
- [ ] Publish release notes.
- [ ] Monitor Search Console for queries and fix pages with low CTR.
- [ ] Add new FAQ entries based on real questions (great for long-tail SEO).
