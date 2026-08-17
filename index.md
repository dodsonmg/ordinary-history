---
layout: page
title: Home
---

Ordinary History is one building historian's record of deep dives into the fabric of old buildings — extensions, trades, tenancies, and the ordinary changes that add up to a building's history — and the people who lived and worked in them. Each building below is its own self-contained history, researched and organized on its own terms.

## Buildings

{% if site.data.buildings.size > 0 %}
<ul>
  {% for building in site.data.buildings %}
    <li>
      <a href="{{ building.url | relative_url }}">{{ building.title }}</a>{% if building.era %} — {{ building.era }}{% endif %}
      {% if building.blurb %}<br>{{ building.blurb }}{% endif %}
    </li>
  {% endfor %}
</ul>
{% else %}
<p>No buildings documented yet — check back soon.</p>
{% endif %}
