# Temporary File for JS Rails documentation

## 04 Server-Side Concerns

- When doing AJAX requests, Rails can tell what type of request was sent and respond appropriately

## 05 Turbolinks

- Turbolinks use AJAX to speed page rendering in most applications

### 05.1 How Turbolinks Work

- If the browser supports `pushState` then Turbolinks can make an AJAX request for the next page and pull it in without reloading the application.

To disable Turbolinks:

```html
<a href="..." data-turbolinks="false">No turbolinks here</a>.
```

To observe when a page loads via turbolinks, use this:

```js
$(document).on "turbolinks:load", ->
  alert "page has loaded!"
```
