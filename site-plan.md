# Ordinary History — Project Plan

Domain: ordinaryhistory.com. Directory/repo name: `ordinary-history`.

A Jekyll + GitHub Pages portfolio for a building historian: deep dives into the fabric of buildings and the people who lived in them. Each building is its own independent Jekyll site, with cross-linking between people and articles *within* a building — buildings themselves don't meaningfully cross-link, so the portfolio is a thin index over otherwise-separate sites rather than one shared data model.

## Design Decisions & Considerations

**Chose Jekyll + GitHub Pages over Substack, WordPress, and Obsidian Publish.**
Rationale: the content is fundamentally relational (people, events, places with heavy cross-links across 300 years) — a poor fit for Substack's chronological/email-first model. Jekyll's collections + Liquid templating handle that structure well. Plain Markdown-in-git is also a strong archival format for a project meant to last decades — durable, portable, and gives free provenance via commit history (who wrote/changed what, when). Cost is effectively zero (GitHub Pages + existing domain). Tradeoff accepted: contributor ergonomics are worse than a hosted CMS/blog platform, so that gets treated as its own design problem (see Contributor Workflow below).

**Considered and set aside for now: Obsidian + Obsidian Publish.**
Very strong fit for the wiki-linking specifically ([[bidirectional links]] out of the box, graph view), and zero-CLI for both writer and reader. Set aside because it's a different architecture (not additive to Jekyll), a recurring cost (~$8-10/mo), and less design/HTML control. Worth revisiting if the Jekyll + contributor-workflow combination proves too much friction later.

**GitHub Pages build mode.**
Native GitHub Pages Jekyll builds run in a restricted "safe mode" (whitelisted plugins only). Plan to build via a GitHub Actions workflow instead, so we're not limited if we later want non-whitelisted plugins.

**Media/assets strategy — decide before the repo grows.**
300 years of residents implies scans/photos. Git repos get slow and bloated with many large binaries. Decide early: Git LFS vs. external image hosting, before real content migration (phase 5).

**Each building is its own independent Jekyll site, not a shared collection scoped by a `building:` field.**
Phase 2 originally modeled people/posts as one shared collection per concept (`_people`, `_posts`) with a `building: <slug>` field for reverse-lookup, plus a `_buildings` collection for the profile page — the same pattern already working for cross-linking people to articles. Reconsidered once it became clear this only fits concepts that are genuinely the same across buildings (a person is a person anywhere); it's the wrong fit for a building's own bespoke organizing ideas, since each building here is really an independent research project unlikely to cross-link with any other, and likely to want its own content types over time (a collection with no equivalent on any other building). A shared collection would mean every building's bespoke ideas piling up as top-level `_foo/` directories in one `_config.yml`, with nothing in the repo signaling which building owns what. Moved to full independence instead: `coopers-row/` and `halloway-house/` are complete, separate Jekyll sites (own `_config.yml`, collections, layouts), and the repo root is a thin portfolio that just links out to them via `_data/buildings.yml`. Cost accepted: no more shared layouts/includes (each building carries its own copy, free to diverge later), no combined local `jekyll serve` (replaced by `bin/build`/`bin/serve`, which run one Jekyll build per site into a combined `_site/`), and cross-building links lose the `{% link %}` fail-loud safety net (they're plain relative links now, since Jekyll can't see across separate `--source` builds). See `README.md`'s "Adding a building" section for the concrete pattern.

**Contributor workflow decision.**
Michael is fine being the human bottleneck initially (no urgency to fully automate). Longer-term option scoped for phase 6: a Claude-managed publish workflow where she compiles/exports from Scrivener to Markdown (the one unavoidable manual step — Claude can't parse the native .scriv binder), drops it in a shared/synced folder, and a custom Cowork skill handles branch creation, commit, and PR via the GitHub API (not local git — she never touches git or CLI). Use a scoped GitHub token (this repo only). Use a PR-preview GitHub Action (e.g. `pr-preview-action`) so she gets a shareable preview link per draft before anything merges to `main`. Merge/publish gated by Michael's review initially; could hand that off to her later.

## 1. Toolchain & Environment Setup
- Install Ruby/Jekyll/Bundler locally
- Create GitHub repo, enable GitHub Pages
- Local build/preview loop (`bin/serve`, running one Jekyll build per site)
- Status: **Complete.** Ruby 4.0.6 via rbenv (pinned in `.ruby-version`, hooked into shell via `~/dotfiles/.common_config`), one shared `bundle install` serving every site's `jekyll build` invocation (see phase 2 status for why there are multiple sites). Repo live at `github.com/dodsonmg/ordinary-history`, deployed via GitHub Actions to `dodsonmg.github.io/ordinary-history` (Pages source: Actions, not branch — avoids the plugin whitelist). Each site's `_config.yml` url is still set to `https://www.ordinaryhistory.com` for the eventual custom domain (phase 7); `bin/build`/the workflow pass a `--baseurl` prefix at build time to match the interim `github.io` path in the meantime — drop that argument once the domain is live.

## 2. Site Architecture & Data Model
- Portfolio (repo root) + one independent Jekyll site per building (`coopers-row/`, `halloway-house/`), each with its own `_people`/`_posts` collections
- Cross-linking strategy, within a building: front-matter references (e.g. `related_people: [id1, id2]`) rendered as links via Liquid includes
- Taxonomy: era/decade, family line, occupation, tags
- URL structure and permalinks
- Status: **Complete for now, architecture reworked once.** Originally one shared site with `_people`/`_posts`/`_buildings` collections cross-linked via a `building: <slug>` field; reworked into fully independent per-building sites — see the "Each building is its own independent Jekyll site" decision above for the full reasoning. Each building now has its own `_people` collection (permalink `/people/:path/`) and `_posts` (articles, including building-fabric changes — a standalone `_changes` collection was tried in phase 3 and folded back into `_posts` before the bigger per-building rework, once it proved to be a display variant of "article tied to a building" rather than a distinct kind of content; those posts carry optional `date_range`/`event_type` front matter). Cross-linking via `related_people: [slug, ...]` front matter, resolved in each building's own `_includes/related-people.html`, wired into its own `_layouts/person.html`/`post.html` — no `building:` field or reverse-lookup include anymore, since everything in a building's site already belongs to it by construction. The portfolio (repo root) holds no content collections at all — just `_data/buildings.yml` (title/era/blurb/url per building) feeding the homepage and `/buildings/` index. Taxonomy beyond `event_type` on change-flavored posts (era/decade, family line, occupation, tags) still not decided — revisit once more buildings' worth of content exists to design against, now per-building rather than sitewide. Next: phase 4.

## 3. Example Content & First Build
- 2–3 sample people with articles, deliberately cross-linked
- Confirm links, tags, and navigation render correctly
- Local preview
- Status: **Complete, expanded to two independent building sites.** 9 Coopers Row (`coopers-row/`) with 5 people (Thomas Thatcher, Jane Thatcher, Margaret Cole, Edward Voss, Ruth Emsley) and 10 posts — 6 ordinary articles plus 4 building-fabric changes (an 1815 extension, an 1834 conversion to a public house, a 1902 conversion to an artist's studio, and a 1932 subdivision into flats later reunified in 1946) — a residential-succession narrative. Halloway House (`halloway-house/`) added afterward specifically to exercise the multi-building structure with a different shape of story: an architecturally significant 1958 brutalist house by architect Rowan Fenwick, 4 people (Fenwick, client Vivian Halloway, and two later owners), and 10 posts — 6 articles plus 4 changes covering its original experimental construction, a well-intentioned but damaging 1986 repair campaign, its 2015 acquisition by a conservation organization, and a 2016–2019 restoration that had to undo the 1986 work as much as repair the original fabric. Both buildings confirmed to build and render fully independently (own `jekyll build` invocation, own layouts, no shared state) with no cross-contamination. All sample content is explicitly marked as placeholder, to be replaced with real research in phase 5. No tags/taxonomy yet beyond `event_type` on change-flavored posts — still deferred (see phase 2 status). Next: phase 4.

## 4. Theme & Design
- Pick/adapt a Jekyll theme
- Light branding (house name, imagery, color)
- Status: **Not started, one piece done early.** Still stock minima, no imagery/color decided. The one thing pulled forward from this phase: once buildings became independent sites (phase 2 rework), each building's header showed only its own name, with no way back to the portfolio — added a small `_includes/header.html` override (per building) with a compact "Ordinary History" link back to the portfolio root, styled via a couple of rules in `assets/main.scss` on top of `@import "minima"`. Rest of phase 4 (theme choice, imagery, color) still pending.

## 5. Migrating Real Content
- Inventory existing material (notes, documents, photos)
- Article template for consistency
- Batch-import process

## 6. Contributor Workflow (non-technical co-author)
- Scrivener → Markdown export process
- Simple preview step before publishing
- Low-friction path to get her drafts into GitHub (via Claude or a small custom tool), without requiring her to use git directly

## 7. Domain & Deployment
- Point existing domain at GitHub Pages
- DNS + HTTPS setup

## 8. Ongoing Maintenance
- Process for adding new people/articles over time
- Search
- Backups / version history
