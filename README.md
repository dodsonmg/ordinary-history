# Ordinary History

Jekyll site for a building historian's deep dives into the fabric of old buildings and the people who lived in them, to be published at ordinaryhistory.com. See `site-plan.md` (one level up) for the overall project plan and design decisions.

## Status

Live at [dodsonmg.github.io/ordinary-history](https://dodsonmg.github.io/ordinary-history/) (temporary path until the custom domain is pointed here — see phase 7). Phases 1–3 of the plan are done: toolchain, the `_people`/`_buildings`/`_changes` collections + cross-linking scaffolding, and sample content proving the relational model end-to-end across **two** buildings — 9 Coopers Row (1 building, 5 people, 6 articles, 4 changes) and Halloway House (1 building, 4 people, 6 articles, 4 changes), the latter added specifically to exercise the multi-building portfolio structure with a distinct narrative (an architecturally significant brutalist house requiring conservation, rather than a residential-succession story). The homepage introduces the site as a building historian's portfolio rather than a single-house microsite, with dedicated `/buildings/`, `/people/`, `/posts/`, and `/changes/` index pages. All sample content is placeholder, to be replaced with real research in phase 5.

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

## Adding content

**A new article**: create `_posts/YYYY-MM-DD-title.md` (the date prefix is a Jekyll filename requirement, even though permalinks don't include it). Front matter:

```yaml
---
layout: post
title: "Some Title"
related_people: [jane-thatcher, thomas-thatcher]
---
```

It shows up on the home page automatically, and everyone listed in `related_people` automatically gets it listed on their own person page under "Articles" — that direction is a reverse lookup, not something you maintain by hand.

**A new person**: create `_people/some-slug.md`:

```yaml
---
layout: person
title: "Full Name"
years: "1900–1980"
related_people: [other-persons-slug]
---
```

They show up on `/people/` automatically. `related_people` here is for direct person-to-person relationships (spouse, parent, sibling), separate from whatever articles reference them.

**Person↔person links are not automatically bidirectional.** If you want Jane's page to show Thomas and vice versa, set `related_people` on both files — only the article→person direction is automatic.

**A building fabric change**: create `_changes/some-slug.md` to document a significant change to a building — an extension, a change of use (public house, artist's studio, tenement), a subdivision, etc.:

```yaml
---
layout: change
title: "Some Change"
date_range: "1834–1861"
event_type: use-change
related_people: [some-persons-slug]
building: some-buildings-slug
---
```

`related_people` and `building` are both optional — use them when the change is tied to a specific person or building. Like articles, a change's `related_people` shows up automatically on the referenced person's page under "Changes," via reverse lookup.

**A building**: create `_buildings/some-slug.md`:

```yaml
---
layout: building
title: "Some Address"
era: "c. 1740–present"
---
```

People, posts, and changes attach to a building via a `building: <slug>` field in their own front matter (not the other way around) — the building page automatically lists everything that references it, via the same reverse-lookup pattern.

**Slugs** are just the filename minus extension (and minus the date prefix, for posts). A typo'd or renamed slug doesn't error the build — it silently renders nothing, so double-check links after renaming a file.

**Inline links in article/bio text**: external links (Wikipedia, an archive record, a place with no page of its own) are just normal markdown — `[some text](https://...)` — nothing special. For links to another page *on this site*, don't hardcode a path like `[Jane Thatcher](/people/jane-thatcher/)` — it'll break under the temporary `/ordinary-history` baseurl (see Deployment note below). Use Jekyll's `link` tag instead, which resolves correctly regardless of `baseurl` and fails the build loudly if the target doesn't exist, rather than silently 404ing:

```liquid
[Jane Thatcher]({% link _people/jane-thatcher.md %})
```

## Deployment

Repo: [github.com/dodsonmg/ordinary-history](https://github.com/dodsonmg/ordinary-history). Pages is configured with **Source: GitHub Actions** (Settings → Pages) rather than "Deploy from a branch" — the workflow in `.github/workflows/pages.yml` handles the build, which avoids GitHub Pages' restricted plugin whitelist. Every push to `main` builds and deploys automatically; check the Actions tab for status.

Note: the workflow currently builds with `--baseurl "/ordinary-history"` to match the interim `github.io` project-page path. Remove that flag once the custom domain (phase 7) is live and Pages serves from root — otherwise assets will 404.
