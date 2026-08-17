# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture: this repo holds several Jekyll sites, not one

The repo root is a thin portfolio site (`_config.yml`, `index.md`, `buildings.md`, `_data/buildings.yml`) that just lists buildings and links out to them. Each building — `coopers-row/`, `halloway-house/` — is its own complete, independent Jekyll site: own `_config.yml`, own `_people`/`_posts` collections, own `_layouts`/`_includes`. Nothing in a building's directory references another building or the portfolio, except plain relative links. See `README.md`'s "Adding a building" section for the concrete pattern, and `site-plan.md` phase 2 status for why (short version: buildings don't meaningfully cross-link and each is likely to need its own bespoke content types over time, so a shared collection keyed by a `building:` field was the wrong fit).

## Before starting work

Check `README.md`'s Status section and `site-plan.md`'s per-phase Status lines first — they're the source of truth for what's done vs. pending. Update both whenever a phase's status changes; this project has a habit of letting them go stale otherwise, which misleads whoever (or whatever) reads them next.

## Commands

```sh
bundle install    # install gems (Jekyll, minima, plugins) per Gemfile.lock — one shared install for every site
bin/serve          # local dev server for the whole portfolio + all buildings, live rebuild, http://localhost:4000
bin/build          # one-off build of everything to _site/ (what CI runs)
```

Plain `bundle exec jekyll serve`/`build` only operate on one `--source` at a time, so they can't build "the whole site" anymore — use `bin/serve`/`bin/build`, which run one Jekyll invocation per site (portfolio + each building) into a combined `_site/`. To work on just one building in isolation, `cd coopers-row && bundle exec jekyll serve` works fine — it's an ordinary, complete Jekyll site on its own.

There is no test suite or linter configured in this repo.

Ruby is managed via **rbenv**, not system Ruby (system Ruby is 2.6.10 — too old for Jekyll 4.3+). The pinned version is tracked in `.ruby-version` (currently 4.0.6). The rbenv shell hook lives in `~/dotfiles/.common_config` — a separate, git-tracked dotfiles repo synced into both zsh (via Oh My Zsh's `custom/` dir) and bash (via `.bashrc`) — **not** in this project. If `rbenv`/`ruby`/`bundle` don't resolve correctly in a shell, that hook may not be sourced yet.

## Before pushing to main

Before every push to `main`, confirm this change is consistent with `CLAUDE.md`, `site-plan.md`'s phase Status lines, and `README.md`'s Status section — update whichever have gone stale as part of the same push, not as separate follow-up work. This is the same check as "Before starting work" above, re-run at the other end of the change.

After pushing, deployment success is checked automatically (a hook runs `gh run watch`). If that hook is ever missing or disabled, fall back to the manual check documented in "Deployment" below — `gh run watch <run-id> --repo dodsonmg/ordinary-history --exit-status`, and verifying against the real deployed URL rather than local `bin/serve`, since the `/ordinary-history` baseurl bug (see below) doesn't reproduce locally.

## Deployment

GitHub Pages **Source is set to "GitHub Actions"** (not "Deploy from a branch") specifically to avoid GitHub's restricted Jekyll plugin whitelist — see `.github/workflows/pages.yml`. Every push to `main` triggers build + deploy automatically. The workflow runs `bin/build /ordinary-history`, which builds every site with a matching `--baseurl` prefix.

The `/ordinary-history` argument matches the temporary `dodsonmg.github.io/ordinary-history/` project-page URL. The real URL will eventually be `ordinaryhistory.com` (phase 7 of `site-plan.md`), at which point every site's `_config.yml` `baseurl: ""` becomes correct on its own and **this argument must be dropped** (call `bin/build` with no argument) — leaving it in place will silently break every CSS/asset link once the site moves to serving from root (this has already happened once, before the multi-site rework). This bug does not reproduce with local `bin/serve`, since that always serves from root — after pushing, verify against the actual deployed URL (or watch the Actions run: `gh run watch <run-id> --repo dodsonmg/ordinary-history --exit-status`), not just localhost.

`_config.yml`'s root-level `exclude:`/`keep_files:` lists exist specifically to make the multi-build work: `exclude` stops the portfolio's own build from also trying to process building directories as ordinary pages, and `keep_files` stops it from deleting `_site/coopers-row`/`_site/halloway-house` (written by their own separate builds) during its cleanup step. Both need a new entry whenever a building is added — see `README.md`'s "Adding a building" section.

## Cross-linking data model

Within a single building's site, people and articles link to each other via `related_people: [slug1, slug2]` in YAML front matter, where each slug is a collection-item filename without extension. This is resolved into rendered links by that building's own `_includes/related-people.html`, which matches slugs against `site.people` — scoped to that building automatically, since a building's site only ever contains its own content.

That include is wired into two layouts, duplicated per building (not shared — each building's `_layouts/` is a separate copy, free to diverge):
- `_layouts/person.html` — for entries in that building's `_people` collection (permalink `/people/:path/`)
- `_layouts/post.html` — a **local override** of minima's gem-provided post layout, needed because minima's own version has no related-people include. If minima is ever upgraded and its post layout changes upstream, this override needs to be manually re-applied on top of the new version, in every building's `_layouts/post.html`.

Any new layout that should support cross-linking needs the same `{% include related-people.html %}` added by hand — it isn't automatic. Buildings don't reference each other's content at all — the portfolio only links *out* to each building's homepage via `_data/buildings.yml`. The one link going the other way, building → portfolio, is the "Ordinary History" link in `_includes/header.html` (also a local override, of minima's header this time) — it computes the portfolio's URL from `site.baseurl` rather than hardcoding a path, since a building's baseurl is always the portfolio's baseurl plus one segment (see `bin/build`). Needs copying into any new building same as `person.html`/`post.html`.

## Pending decisions (from site-plan.md)

- **Media/assets strategy**: Git LFS vs. external image hosting — must be decided before phase 5 (real content migration), since scans/photos will otherwise bloat the git repo. Now a per-building decision in principle, though likely to land the same way for both.
- **Taxonomy**: era/decade, family line, occupation, tags — deliberately deferred until phase 3 sample content exists to design against, now per-building rather than sitewide.
- **Per-building toolchain divergence**: all buildings currently share one root `Gemfile`/theme. If a building wants a different theme/plugin set, it can get its own `Gemfile` — not built yet since no building needs it.
