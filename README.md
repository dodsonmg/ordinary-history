# Ordinary History

Jekyll site tracing the people who lived in the house over ~300 years, to be published at ordinaryhistory.com. See `site-plan.md` (one level up) for the overall project plan and design decisions.

## Status

Toolchain scaffold only — no real content yet, no theme customization yet. This is phase 1 of the plan.

## Local setup (run these yourself — see note below)

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

## GitHub setup

1. Create a new **empty** repo on GitHub named `ordinary-history` (no README/gitignore/license — this folder already has them).
2. From this folder:
   ```
   git init
   git add .
   git commit -m "Initial Jekyll scaffold"
   git branch -M main
   git remote add origin <your-repo-url>
   git push -u origin main
   ```
3. In the repo's Settings → Pages, set **Source** to "GitHub Actions" (not "Deploy from a branch") — the workflow in `.github/workflows/pages.yml` handles the build, which avoids GitHub Pages' restricted plugin whitelist.
4. Push to `main` and the site will build and deploy automatically. The Actions tab shows build status; the Pages settings page shows the live URL once deployed.

## Note on this scaffold

This was hand-authored rather than generated via `jekyll new`, because the sandbox this was built in has no outbound access to rubygems.org or github.com — package installs and git operations aren't possible from there. Everything above needs to be run and verified on your own machine. If `bundle install` or `jekyll serve` throws errors, paste the output back and we'll debug from there.
