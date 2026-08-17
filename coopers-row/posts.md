---
layout: page
title: Posts
permalink: /posts/
---

{% if site.posts.size > 0 %}
<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      {% if post.date_range %} — {{ post.date_range }}{% else %} — {{ post.date | date: "%b %-d, %Y" }}{% endif %}
      {% if post.event_type %} · {{ post.event_type }}{% endif %}
    </li>
  {% endfor %}
</ul>
{% else %}
<p>No posts yet — check back soon.</p>
{% endif %}
