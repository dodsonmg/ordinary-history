---
layout: page
title: Home
---

Ordinary History is one building historian's record of deep dives into the fabric of old buildings — extensions, trades, tenancies, and the ordinary changes that add up to a building's history — and the people who lived and worked in them.

## Buildings

{% if site.buildings.size > 0 %}
<ul>
  {% for building in site.buildings %}
    <li><a href="{{ building.url | relative_url }}">{{ building.title }}</a>{% if building.era %} — {{ building.era }}{% endif %}</li>
  {% endfor %}
</ul>
{% else %}
<p>No buildings documented yet — check back soon.</p>
{% endif %}

Or browse by [Posts]({% link posts.md %}) or [People]({% link people.md %}).
