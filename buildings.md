---
layout: page
title: Buildings
permalink: /buildings/
---

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
