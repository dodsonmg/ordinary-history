# Ordinary History

A portfolio of Jekyll sites for a building historian's deep dives into the fabric of old buildings and the people who lived in them, to be published at ordinaryhistory.com. See `site-plan.md` (one level up) for the overall project plan and design decisions.

**This repo is not one Jekyll site — it's several.** The repo root is a thin portfolio site that just lists buildings and links out to them. Each building (`coopers-row/`, `halloway-house/`) is its own fully independent Jekyll site: its own `_config.yml`, its own `_people`/`_posts` collections, its own layouts and includes. Nothing in one building's directory references another building or the portfolio — buildings are separate projects that happen to live in one repo, not branches of one shared data model. See "Adding a building" below for why, and `site-plan.md`'s phase 2 status for the fuller rationale.

## Status

Live at [dodsonmg.github.io/ordinary-history](https://dodsonmg.github.io/ordinary-history/) (temporary path until the custom domain is pointed here — see phase 7). Phases 1–3 of the plan are done: toolchain, and sample content proving out **two** independent building sites — 9 Coopers Row (5 people, 10 posts) and Halloway House (4 people, 10 posts), the latter added specifically to exercise the multi-building portfolio structure with a distinct narrative (an architecturally significant brutalist house requiring conservation, rather than a residential-succession story). The architecture was reworked from a single shared site (one `_people`/`_posts` collection with a `building:` field on every entry) into fully separate per-building sites, once it became clear buildings don't meaningfully cross-link and each is likely to need its own organizing principles over time — see `site-plan.md` phase 2 for the full reasoning. All sample content is placeholder, to be replaced with real research in phase 5.

## Local setup

1. Install Ruby if you don't have it (macOS ships an old system Ruby; recommend `rbenv` or `asdf` rather than using it directly):
   ```
   brew install rbenv
   rbenv install 4.0.6
   rbenv local 4.0.6
   ```
2. Install dependencies (one shared `Gemfile`/`bundle install` covers every site — see "One shared toolchain" below):
   ```
   gem install bundler
   bundle install
   ```
3. Build and preview everything locally:
   ```
   bin/serve
   ```
   Then open http://localhost:4000. Plain `jekyll serve` can't do this anymore — Jekyll only builds one `--source` at a time, and there are now three sites (portfolio + 2 buildings). `bin/serve` runs a `jekyll build --watch` per building in the background and serves the combined output with `jekyll serve --watch` in the foreground, so you still get one command and auto-rebuild-on-save. `bin/build` does the equivalent one-shot build (what CI runs) if you just want the output in `_site/` without a server.

   To work on just one building without the portfolio wrapper, `cd coopers-row && bundle exec jekyll serve` works unmodified — each building is a complete, ordinary Jekyll site on its own.

## Adding content within a building

These all apply inside a building's own directory (e.g. `coopers-row/`) — nothing here needs a `building:` field anymore, since everything in a building's site already belongs to that building by construction.

**A new article**: create `_posts/YYYY-MM-DD-title.md` (the date prefix is a Jekyll filename requirement, even though permalinks don't include it). Front matter:

```yaml
---
layout: post
title: "Some Title"
related_people: [jane-thatcher, thomas-thatcher]
---
```

`related_people` is optional. It shows up on the building's home page automatically, and everyone listed in `related_people` automatically gets it listed on their own person page under "Articles" — that direction is a reverse lookup, not something you maintain by hand.

**A building-fabric change** (an extension, a change of use like public house/artist's studio/tenement, a subdivision, etc.) is just an article with two extra front-matter fields — there's no separate collection for these:

```yaml
---
layout: post
title: "Some Change"
date_range: "1834–1861"
event_type: use-change
related_people: [some-persons-slug]
---
```

When `date_range` is present it's shown instead of the post's publish date, since the two mean different things: `date_range` is when the change actually happened, while the `YYYY-MM-DD` filename prefix is just publish/sort order and carries no historical meaning. `event_type` is a free-text label (`use-change`, `subdivision`, `renovation`, etc.) shown alongside it — no fixed vocabulary yet.

**A new person**: create `_people/some-slug.md`:

```yaml
---
layout: person
title: "Full Name"
years: "1900–1980"
related_people: [other-persons-slug]
---
```

They show up on the building's `/people/` page automatically. `related_people` here is for direct person-to-person relationships (spouse, parent, sibling), separate from whatever articles reference them.

**Person↔person links are not automatically bidirectional.** If you want Jane's page to show Thomas and vice versa, set `related_people` on both files — only the article→person direction is automatic.

**Slugs** are just the filename minus extension (and minus the date prefix, for posts). A typo'd or renamed slug doesn't error the build — it silently renders nothing, so double-check links after renaming a file.

**Inline links to another page in the same building**: don't hardcode a path like `[Jane Thatcher](/people/jane-thatcher/)` — it'll break under the temporary `/ordinary-history` baseurl (see Deployment note below). Use Jekyll's `link` tag instead, which resolves correctly regardless of `baseurl` and fails the build loudly if the target doesn't exist, rather than silently 404ing:

```liquid
[Jane Thatcher]({% link _people/jane-thatcher.md %})
```

`{% link %}` only works for targets inside the *same* Jekyll build — it can't reach across into another building's site or the portfolio (those are separate `jekyll build` invocations with no visibility into each other). Links between buildings, or from a building back to the portfolio, are just plain markdown links (e.g. `[Home](/)`) and won't fail the build if broken — a trade-off for buildings being genuinely independent, not something to work around.

External links (Wikipedia, an archive record, a place with no page of its own) are just normal markdown — `[some text](https://...)` — nothing special.

## Adding a building

Buildings are deliberately not a shared collection — each one is its own Jekyll site, because in practice buildings don't cross-link much and each has its own shape of story (one might eventually want a collection type with no equivalent anywhere else — a "things" collection, a "cases" collection, whatever fits that building). Scaffolding a new one:

1. Create `some-building/` at the repo root, copying the shape of `coopers-row/`: its own `_config.yml` (set `title`, `description`, and `baseurl: "/some-building"`), `_people/`, `_posts/`, `_layouts/` (`person.html`, `post.html`), `_includes/` (`related-people.html`, `related-articles.html`), plus `index.md`, `people.md`, `posts.md`.
2. Add it to `_config.yml`'s root-level `exclude:` and `keep_files:` lists (see the comments there for why both are needed) — otherwise the portfolio build will either choke on it as a stray page or delete its output on rebuild.
3. Register it in `_data/buildings.yml` (title, era, blurb, `url: "/some-building/"`) so it shows up on the portfolio homepage and `/buildings/`.
4. Add the new site to `bin/build`, `bin/serve`, and `.github/workflows/pages.yml`'s build step, following the pattern already there for `coopers-row`/`halloway-house`.

**One shared toolchain, for now.** All buildings currently use plain minima with no theme customization, so one root `Gemfile`/`bundle install` serves every site's `jekyll build` invocation. If a building eventually wants a different theme or plugin set, it can get its own `Gemfile` and be built with `bundle install --gemfile=some-building/Gemfile` — not needed yet, so not built preemptively.

## Deployment

Repo: [github.com/dodsonmg/ordinary-history](https://github.com/dodsonmg/ordinary-history). Pages is configured with **Source: GitHub Actions** (Settings → Pages) rather than "Deploy from a branch" — the workflow in `.github/workflows/pages.yml` handles the build, which avoids GitHub Pages' restricted plugin whitelist. Every push to `main` builds and deploys automatically; check the Actions tab for status.

CI runs `bin/build /ordinary-history`, which builds the portfolio and every building (each with its own `--baseurl`) into one combined `_site/`, then uploads that as the Pages artifact. The `/ordinary-history` prefix is temporary, matching the interim `github.io` project-page path — remove it (call `bin/build` with no argument) once the custom domain (phase 7) is live and Pages serves from root, otherwise assets will 404.
