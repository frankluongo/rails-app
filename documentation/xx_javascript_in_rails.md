# Working with JavaScript in Rails

[This guide comes from Edge Guides](https://edgeguides.rubyonrails.org/working_with_javascript_in_rails.html)

## 01 An Introduction to AJAX

- AJAX is using JavaScript to request content from a server and dynamically update a page on the fly.
- Rails ships with CoffeeScript

Example:

```js
$.ajax(url: "/test").done (html) ->
  $("#results").append html
```

## 02 Unobtrusive JavaScript

- Unobtrusive JavaScript means attaching `data` attributes to elements to targeting them that way

Here's an example of unobtrusive JavaScript:

```coffee
@paintIt = (element, backgroundColor, textColor) ->
  element.style.backgroundColor = backgroundColor
  if textColor?
    element.style.color = textColor

$ ->
  $("a[data-background-color]").click (e) ->
    e.preventDefault()

    backgroundColor = $(this).data("background-color")
    textColor = $(this).data("text-color")
    paintIt(this, backgroundColor, textColor)
``

```html
<a href="#" data-background-color="#990000">Paint it red</a>
<a href="#" data-background-color="#009900" data-text-color="#FFFFFF">Paint it green</a>
<a href="#" data-background-color="#000099" data-text-color="#FFFFFF">Paint it blue</a>
```

## 03 Built-In Helpers

### 03.1 Remote Helpers

- Rails provides built-in helpers to make using unobtrusive JavaScript easier as long as you have the asset pipeline set up

#### 03.1.1 `form_with`

- `form_with` assumes you'll be using ajax

This

```erb
<%= form_with(model: @article) do |f| %>
  ...
<% end %>
```

Generates this

```html
<form action="/articles" accept-charset="UTF-8" method="post" data-remote="true">
  ...
</form>
```

- `data-remote="true"` will cause the form to be submitted via ajax

To add an event on form submission, do the following

```coffee
$(document).ready ->
  $("#new_article").on("ajax:success", (event) ->
    [data, status, xhr] = event.detail
    $("#new_article").append xhr.responseText
  ).on "ajax:error", (event) ->
    $("#new_article").append "<p>ERROR</p>"
```

#### 03.1.2 `link_to`

This helpers assists with generating links

```erb
<%= link_to "an article", @article, remote: true %>
```

```html
<a href="/articles/1" data-remote="true">an article</a>
```

This can be useful for deleting things like this:

```erb
<%= link_to "Delete article", @article, remote: true, method: :delete %>
```

```coffee
$ ->
  $("a[data-remote]").on "ajax:success", (event) ->
    alert "The article was deleted."
```

#### 03.1.3 `button_to`

Helps create buttons

```erb
<%= button_to "An article", @article, remote: true %>
```

```html
<form action="/articles/1" class="button_to" data-remote="true" method="post">
  <input type="submit" value="An article" />
</form>
```

### 03.2 Customize Remote Elements

There are a handful of `data` attributes built-in to Rails to customize remote elements

#### 03.2.1 `data-method`

You can specify the data-method as either `GET` or `POST`

#### 03.2.2 `data-url` and `data-params`

This is helpful for triggering actions on elements that may not reference a URL directly

```html
<input type="checkbox" data-remote="true"
    data-url="/update" data-params="id=10" data-method="put">
```

#### 03.2.3 `data-type`

You can specify the Ajax `data-type`

### 03.3 Confirmations

You can add `data-confirm` attribute on links and forms. This will present the user with a `confirm()` dialog containing the attribute's text.

```erb
<%= link_to "Dangerous zone", dangerous_zone_path,
  data: { confirm: 'Are you sure?' } %>
```

**NOTE**: Add this to submit buttons when using on a form, not to the form itself

You can also customize this by listening to the `confirm` event that will be fired, canceling its default action and rolling your own.

### 03.4 Automatic Disabling

Disable form inputs while form is submitting using `data-disable-with` -- this will prevent accidental double-clicks by a user

```erb
<%= form_with(model: @article.new) do |f| %>
  <%= f.submit data: { "disable-with": "Saving..." } %>
<%= end %>
```

```html
<input data-disable-with="Saving..." type="submit">
```

### 03.5 Rails-ujs Event Handlers

Rails 5.1 introduced Rails-UJS and dropped jQuery as a dependency. As a result, the Unobtrusive JS has been re-written to operate with jQuery. This causes custom events to be fired.

| Event name      | Extra parameters (event.detail) | Fired                                                        |
|-----------------|---------------------------------|--------------------------------------------------------------|
| ajax:before     |                                 | Before the whole ajax business.                              |
| ajax:beforeSend | [xhr, options]                  | Before the request is sent.                                  |
| ajax:send       | [xhr]                           | When the request is sent.                                    |
| ajax:stopped    |                                 | When the request is stopped.                                 |
| ajax:success    | [response, status, xhr]         | After completion, if the response was a success.             |
| ajax:error      | [response, status, xhr]         | After completion, if the response was an error.              |
| ajax:complete   | [xhr, status]                   | After the request has been completed, no matter the outcome. |

Example:

```coffee
document.body.addEventListener('ajax:success', function(event) {
  var detail = event.detail;
  var data = detail[0], status = detail[1], xhr = detail[2];
})
```

### 03.6 Stoppable Events

- Use `event.preventDefault()` on `ajax:before` or `ajax:beforeSend` to invoke this event
- Useful for making your own AJAX file upload workaround

## 04 Server-Side Concerns

- When doing AJAX requests, Rails can tell what type of request was sent and respond appropriately

### 04.1 A Simple Example

Let's say you want to show some users and display a form to add new ones...

`users_controller.rb`

```rb
class UsersController < ApplicationController
  def index
    @users = User.all
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.js
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

end
```

`app/views/users/index.html.erb`

```erb
<b>Users</b>

<ul id="users">
<%= render @users %>
</ul>

<br>

<%= form_with(model: @user) do |f| %>
  <%= f.label :name %><br>
  <%= f.text_field :name %>
  <%= f.submit %>
<% end %>
```

`app/views/users/_user.html.erb`

```erb
<li><%= user.name %></li>
```

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
