---
layout: page
title: Posts
permalink: /posts/
---

{% if site.posts.size > 0 %}
<ul>
  {% for post in site.posts %}
    {% assign b = site.buildings | where: "slug", post.building | first %}
    <li>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      — {{ post.date | date: "%b %-d, %Y" }}
      {% if b %} · <a href="{{ b.url | relative_url }}">{{ b.title }}</a>{% endif %}
    </li>
  {% endfor %}
</ul>
{% else %}
<p>No posts yet — check back soon.</p>
{% endif %}
