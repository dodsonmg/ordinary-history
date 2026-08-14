# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Before starting work

Check `README.md`'s Status section and `site-plan.md`'s per-phase Status lines first — they're the source of truth for what's done vs. pending. Update both whenever a phase's status changes; this project has a habit of letting them go stale otherwise, which misleads whoever (or whatever) reads them next.

## Commands

```sh
bundle install              # install gems (Jekyll, minima, plugins) per Gemfile.lock
bundle exec jekyll serve    # local dev server with live rebuild, http://localhost:4000
bundle exec jekyll build    # one-off build to _site/
```

There is no test suite or linter configured in this repo.

Ruby is managed via **rbenv**, not system Ruby (system Ruby is 2.6.10 — too old for Jekyll 4.3+). The pinned version is tracked in `.ruby-version` (currently 4.0.6). The rbenv shell hook lives in `~/dotfiles/.common_config` — a separate, git-tracked dotfiles repo synced into both zsh (via Oh My Zsh's `custom/` dir) and bash (via `.bashrc`) — **not** in this project. If `rbenv`/`ruby`/`bundle` don't resolve correctly in a shell, that hook may not be sourced yet.

## Deployment

GitHub Pages **Source is set to "GitHub Actions"** (not "Deploy from a branch") specifically to avoid GitHub's restricted Jekyll plugin whitelist — see `.github/workflows/pages.yml`. Every push to `main` triggers build + deploy automatically.

The workflow currently builds with `--baseurl "/ordinary-history"` to match the temporary `dodsonmg.github.io/ordinary-history/` project-page URL. The real URL will eventually be `ordinaryhistory.com` (phase 7 of `site-plan.md`), at which point `_config.yml`'s `baseurl: ""` becomes correct on its own and **this flag must be removed** — leaving it in place will silently break every CSS/asset link once the site moves to serving from root (this has already happened once). This bug does not reproduce with local `jekyll serve`, since that always serves from root — after pushing, verify against the actual deployed URL (or watch the Actions run: `gh run watch <run-id> --repo dodsonmg/ordinary-history --exit-status`), not just localhost.

## Cross-linking data model

People and articles link to each other via `related_people: [slug1, slug2]` in YAML front matter, where each slug is a collection-item filename without extension. This is resolved into rendered links by `_includes/related-people.html`, which matches slugs against `site.people`.

That include is wired into two layouts:
- `_layouts/person.html` — for entries in the `_people` collection (`_config.yml`, permalink `/people/:path/`)
- `_layouts/post.html` — a **local override** of minima's gem-provided post layout, needed because minima's own version has no related-people include. If minima is ever upgraded and its post layout changes upstream, this override needs to be manually re-applied on top of the new version.

Any new layout that should support cross-linking needs the same `{% include related-people.html %}` added by hand — it isn't automatic.

## Pending decisions (from site-plan.md)

- **Media/assets strategy**: Git LFS vs. external image hosting — must be decided before phase 5 (real content migration), since scans/photos will otherwise bloat the git repo.
- **Taxonomy**: era/decade, family line, occupation, tags — deliberately deferred until phase 3 sample content exists to design against.
