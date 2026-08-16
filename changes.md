---
layout: page
title: Changes
permalink: /changes/
---

{% if site.changes.size > 0 %}
<ul>
  {% for change in site.changes %}
    {% assign b = site.buildings | where: "slug", change.building | first %}
    <li>
      <a href="{{ change.url | relative_url }}">{{ change.title }}</a>
      {% if change.date_range %} — {{ change.date_range }}{% endif %}
      {% if change.event_type %} · {{ change.event_type }}{% endif %}
      {% if b %} · <a href="{{ b.url | relative_url }}">{{ b.title }}</a>{% endif %}
    </li>
  {% endfor %}
</ul>
{% else %}
<p>No changes documented yet — check back soon.</p>
{% endif %}
