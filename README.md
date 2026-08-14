# Ordinary History

Jekyll site tracing the people who lived in the house over ~300 years, to be published at ordinaryhistory.com. See `site-plan.md` (one level up) for the overall project plan and design decisions.

## Status

Live at [dodsonmg.github.io/ordinary-history](https://dodsonmg.github.io/ordinary-history/) (temporary path until the custom domain is pointed here — see phase 7). Phases 1–2 of the plan are done: toolchain, and the `_people` collection + cross-linking scaffolding. No real content yet — that's phase 3.

## Local setup

1. Install Ruby if you don't have it (macOS ships an old system Ruby; recommend `rbenv` or `asdf` rather than using it directly):
   ```
   brew install rbenv
   rbenv install 4.0.6
   rbenv local 4.0.6
   ```
2. Install dependencies:
   ```
   gem install bundler
   bundle install
   ```
3. Build and preview locally:
   ```
   bundle exec jekyll serve
   ```
   Then open http://localhost:4000

## Deployment

Repo: [github.com/dodsonmg/ordinary-history](https://github.com/dodsonmg/ordinary-history). Pages is configured with **Source: GitHub Actions** (Settings → Pages) rather than "Deploy from a branch" — the workflow in `.github/workflows/pages.yml` handles the build, which avoids GitHub Pages' restricted plugin whitelist. Every push to `main` builds and deploys automatically; check the Actions tab for status.

Note: the workflow currently builds with `--baseurl "/ordinary-history"` to match the interim `github.io` project-page path. Remove that flag once the custom domain (phase 7) is live and Pages serves from root — otherwise assets will 404.
