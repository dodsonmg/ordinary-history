# Ordinary History — Project Plan

Domain: ordinaryhistory.com. Directory/repo name: `ordinary-history`.

A Jekyll + GitHub Pages site of blog posts/articles about the people who lived in the house over ~300 years, with heavy cross-linking between people, events, and places.

## Design Decisions & Considerations

**Chose Jekyll + GitHub Pages over Substack, WordPress, and Obsidian Publish.**
Rationale: the content is fundamentally relational (people, events, places with heavy cross-links across 300 years) — a poor fit for Substack's chronological/email-first model. Jekyll's collections + Liquid templating handle that structure well. Plain Markdown-in-git is also a strong archival format for a project meant to last decades — durable, portable, and gives free provenance via commit history (who wrote/changed what, when). Cost is effectively zero (GitHub Pages + existing domain). Tradeoff accepted: contributor ergonomics are worse than a hosted CMS/blog platform, so that gets treated as its own design problem (see Contributor Workflow below).

**Considered and set aside for now: Obsidian + Obsidian Publish.**
Very strong fit for the wiki-linking specifically ([[bidirectional links]] out of the box, graph view), and zero-CLI for both writer and reader. Set aside because it's a different architecture (not additive to Jekyll), a recurring cost (~$8-10/mo), and less design/HTML control. Worth revisiting if the Jekyll + contributor-workflow combination proves too much friction later.

**GitHub Pages build mode.**
Native GitHub Pages Jekyll builds run in a restricted "safe mode" (whitelisted plugins only). Plan to build via a GitHub Actions workflow instead, so we're not limited if we later want non-whitelisted plugins.

**Media/assets strategy — decide before the repo grows.**
300 years of residents implies scans/photos. Git repos get slow and bloated with many large binaries. Decide early: Git LFS vs. external image hosting, before real content migration (phase 5).

**Contributor workflow decision.**
Michael is fine being the human bottleneck initially (no urgency to fully automate). Longer-term option scoped for phase 6: a Claude-managed publish workflow where she compiles/exports from Scrivener to Markdown (the one unavoidable manual step — Claude can't parse the native .scriv binder), drops it in a shared/synced folder, and a custom Cowork skill handles branch creation, commit, and PR via the GitHub API (not local git — she never touches git or CLI). Use a scoped GitHub token (this repo only). Use a PR-preview GitHub Action (e.g. `pr-preview-action`) so she gets a shareable preview link per draft before anything merges to `main`. Merge/publish gated by Michael's review initially; could hand that off to her later.

## 1. Toolchain & Environment Setup
- Install Ruby/Jekyll/Bundler locally
- Create GitHub repo, enable GitHub Pages
- Local build/preview loop (`bundle exec jekyll serve`)
- Status: **Complete.** Ruby 4.0.6 via rbenv (pinned in `.ruby-version`, hooked into shell via `~/dotfiles/.common_config`), dependencies via `bundle install`. Repo live at `github.com/dodsonmg/ordinary-history`, deployed via GitHub Actions to `dodsonmg.github.io/ordinary-history` (Pages source: Actions, not branch — avoids the plugin whitelist). `_config.yml` url is still set to `https://www.ordinaryhistory.com` for the eventual custom domain (phase 7); the workflow overrides `--baseurl` at build time to match the interim `github.io` path in the meantime — remove that override once the domain is live.

## 2. Site Architecture & Data Model
- Collections: `_people`, `_posts` (articles), possibly `_places`/`_events`
- Cross-linking strategy: front-matter references (e.g. `related_people: [id1, id2]`) rendered as links via Liquid includes
- Taxonomy: era/decade, family line, occupation, tags
- URL structure and permalinks
- Status: **Complete for now.** `_people` collection added (`_config.yml`, permalink `/people/:path/`); `_places`/`_events` deliberately deferred until real content shows a need for them. Cross-linking via `related_people: [slug, ...]` front matter, resolved by filename slug in `_includes/related-people.html`, wired into both `_layouts/person.html` and a local override of `_layouts/post.html`. `/people/` index page added. Taxonomy (era/decade, family line, occupation, tags) not yet decided — revisit once phase 3 sample content exists to design against. Next: phase 3.

## 3. Example Content & First Build
- 2–3 sample people with articles, deliberately cross-linked
- Confirm links, tags, and navigation render correctly
- Local preview

## 4. Theme & Design
- Pick/adapt a Jekyll theme
- Light branding (house name, imagery, color)

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
