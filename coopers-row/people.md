---
layout: page
title: People
permalink: /people/
---

{% if site.people.size > 0 %}
<ul>
  {% for person in site.people %}
    <li><a href="{{ person.url | relative_url }}">{{ person.title }}</a>{% if person.years %} ({{ person.years }}){% endif %}</li>
  {% endfor %}
</ul>
{% else %}
<p>No people yet — check back soon.</p>
{% endif %}
