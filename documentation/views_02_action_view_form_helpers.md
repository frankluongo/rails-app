# Action View Form Helpers

[This tutorial comes from Edge Guides](https://edgeguides.rubyonrails.org/form_helpers.html)

## 01 Dealing With Basic Forms

Main form helper is `form_with`

```erb
<%= form_with do %>
  Form contents
<% end %>
```

When called without arguments, it will create a form tag which will POST to the current page on submit. It may look something like this:

```html
<form accept-charset="UTF-8" action="/" data-remote="true" method="post">
  <input name="authenticity_token" type="hidden" value="J7CBxfHalt49OSHp27hblqK20c9PgwJ108nDHX/8Cts=" />
  Form contents
</form>
```

The hidden input is a security feature of Rails

### 01.1 A Generic Search Form

```erb
<%= form_with(url: "/search", method: "get") do %>
  <%= label_tag(:q, "Search for:") %>
  <%= text_field_tag(:q) %>
  <%= submit_tag("Search") %>
<% end %>
```

Will generate...

```html
<form accept-charset="UTF-8" action="/search" data-remote="true" method="get">
  <label for="q">Search for:</label>
  <input id="q" name="q" type="text" />
  <input name="commit" type="submit" value="Search" data-disable-with="Search" />
</form>
```

NOTES:

- Passing `url: my_specified_path` to `form_with` tells the form where to make the request.
- For every form input, an ID attribute is generated from its name ("q" in above example). These IDs can be very useful for CSS styling or manipulation of form controls with JavaScript.
- Use "GET" as the method for search forms. This allows users to bookmark a specific search and get back to it. More generally Rails encourages you to use the right HTTP verb for an action.

### 01.2 Helpers For Generating Form Elements

- Rails provides helpers for generating common form inputs.
- First param of these is always the name of the input
- This gets passed along with the data to the Controller

#### 01.2.1 Checkboxes

```erb
<%= check_box_tag(:pet_dog) %>
<%= label_tag(:pet_dog, "I own a dog") %>
<%= check_box_tag(:pet_cat) %>
<%= label_tag(:pet_cat, "I own a cat") %>
```

```html
<input id="pet_dog" name="pet_dog" type="checkbox" value="1" />
<label for="pet_dog">I own a dog</label>
<input id="pet_cat" name="pet_cat" type="checkbox" value="1" />
<label for="pet_cat">I own a cat</label>
```

#### 01.2.2 Radio Buttons

```erb
<%= radio_button_tag(:age, "child") %>
<%= label_tag(:age_child, "I am younger than 21") %>
<%= radio_button_tag(:age, "adult") %>
<%= label_tag(:age_adult, "I am over 21") %>
```

```html
<input id="age_child" name="age" type="radio" value="child" />
<label for="age_child">I am younger than 21</label>
<input id="age_adult" name="age" type="radio" value="adult" />
<label for="age_adult">I am over 21</label>
```

NOTE: Always use labels for checkbox and radio buttons. They associate text with a specific option and, by expanding the clickable region, make it easier for users to click the inputs.

### 01.3 Other Helpers of Interest

```erb
<%= text_area_tag(:message, "Hi, nice site", size: "24x6") %>
<%= password_field_tag(:password) %>
<%= hidden_field_tag(:parent_id, "5") %>
<%= search_field(:user, :name) %>
<%= telephone_field(:user, :phone) %>
<%= date_field(:user, :born_on) %>
<%= datetime_local_field(:user, :graduation_day) %>
<%= month_field(:user, :birthday_month) %>
<%= week_field(:user, :birthday_week) %>
<%= url_field(:user, :homepage) %>
<%= email_field(:user, :address) %>
<%= color_field(:user, :favorite_color) %>
<%= time_field(:task, :started_at) %>
<%= number_field(:product, :price, in: 1.0..20.0, step: 0.5) %>
<%= range_field(:product, :discount, in: 1..100) %>
```

```html
<textarea id="message" name="message" cols="24" rows="6">Hi, nice site</textarea>
<input id="password" name="password" type="password" />
<input id="parent_id" name="parent_id" type="hidden" value="5" />
<input id="user_name" name="user[name]" type="search" />
<input id="user_phone" name="user[phone]" type="tel" />
<input id="user_born_on" name="user[born_on]" type="date" />
<input id="user_graduation_day" name="user[graduation_day]" type="datetime-local" />
<input id="user_birthday_month" name="user[birthday_month]" type="month" />
<input id="user_birthday_week" name="user[birthday_week]" type="week" />
<input id="user_homepage" name="user[homepage]" type="url" />
<input id="user_address" name="user[address]" type="email" />
<input id="user_favorite_color" name="user[favorite_color]" type="color" value="#000000" />
<input id="task_started_at" name="task[started_at]" type="time" />
<input id="product_price" max="20.0" min="1.0" name="product[price]" step="0.5" type="number" />
<input id="product_discount" max="100" min="1" name="product[discount]" type="range" />
```

- Hidden inputs can be changed with JavaScript
- Prevent Passwords from being logged

## 02 Dealing With Model Objects

### 02.1 Model Object Helpers

To help with creating or editing model objects, Rails provides things like this...

```erb
<%= text_field(:person, :name) %>
```

```html
<input id="person_name" name="person[name]" type="text" value="Henry" />
```

### 02.2 Binding a Form to An Object

Rails provides an easy way to bind a form to an object

```erb
<%= form_with model: @article, class: "nifty_form" do |f| %>
  <%= f.text_field :title %>
  <%= f.text_area :body, size: "60x12" %>
  <%= f.submit "Create" %>
<% end %>
```

```html
<form class="nifty_form" action="/articles" accept-charset="UTF-8" data-remote="true" method="post">
  <input type="hidden" name="authenticity_token" value="NRkFyRWxdYNfUg7vYxLOp2SLf93lvnl+QwDWorR42Dp6yZXPhHEb6arhDOIWcqGit8jfnrPwL781/xlrzj63TA==" />
  <input type="text" name="article[title]" id="article_title" />
  <textarea name="article[body]" id="article_body" cols="60" rows="12"></textarea>
  <input type="submit" name="commit" value="Create" data-disable-with="Create" />
</form>
```

You can also bind multiple objects in one form

```erb
<%= form_with model: @person do |person_form| %>
  <%= person_form.text_field :name %>
  <%= fields_for :contact_detail, @person.contact_detail do |contact_detail_form| %>
    <%= contact_detail_form.text_field :phone_number %>
  <% end %>
<% end %>
```

```html
<form action="/people" accept-charset="UTF-8" data-remote="true" method="post">
  <input type="hidden" name="authenticity_token" value="bL13x72pldyDD8bgtkjKQakJCpd4A8JdXGbfksxBDHdf1uC0kCMqe2tvVdUYfidJt0fj3ihC4NxiVHv8GVYxJA==" />
  <input type="text" name="person[name]" id="person_name" />
  <input type="text" name="contact_detail[phone_number]" id="contact_detail_phone_number" />
</form>
```

### 02.3 Relying on Record Identification

- Set up objects as a resource when you plan to edit them

```rb
## Creating a new article
# long-style:
form_with(model: @article, url: articles_path)
# short-style:
form_with(model: @article)

## Editing an existing article
# long-style:
form_with(model: @article, url: article_path(@article), method: "patch")
# short-style:
form_with(model: @article)
```

#### 02.3.1 Dealing With Namespaces

```rb
form_with model: [:admin, @article]
form_with model: [:admin, :management, @article]
```

### 02.4 How do Forms with PATCH, PUT or DELETE Methods Work?

Since most browsers don't support the necessary methods, Rails works around them like so:

```rb
form_with(url: search_path, method: "patch")
```

```html
<form accept-charset="UTF-8" action="/search" data-remote="true" method="post">
  <input name="_method" type="hidden" value="patch" />
  <input name="authenticity_token" type="hidden" value="f755bb0ed134b76c432144748a6d4b7a7ddf2b71" />
  ...
</form>
```

- Requests are sent using AJAX by default but can be set to not by using `local: true`

## 03 Making Select Boxes With Ease

Making select boxes can be a pain

### 03.1 The Select And Option Tags

```erb
<%= select_tag(:city_id, raw('<option value="1">Lisbon</option><option value="2">Madrid</option><option value="3">Berlin</option>')) %>
```

Do dynamically create options:

```erb
<%= options_for_select([['Lisbon', 1], ['Madrid', 2], ['Berlin', 3]]) %>

<%= select_tag(:city_id, options_for_select(...)) %>


<%= options_for_select([['Lisbon', 1], ['Madrid', 2], ['Berlin', 3]], 2) %>

# Pre-select values
<%= options_for_select([['Lisbon', 1], ['Madrid', 2], ['Berlin', 3]], 2) %>

# Arbitrary Attributes
<%= options_for_select(
  [
    ['Lisbon', 1, { 'data-size' => '2.8 million' }],
    ['Madrid', 2, { 'data-size' => '3.2 million' }],
    ['Berlin', 3, { 'data-size' => '3.4 million' }]
  ], 2
) %>
```

### 03.2 Select Boxes Dealing With Model Objects

```erb
@person = Person.new(city_id: 2)
<%= select(:person, :city_id, [['Lisbon', 1], ['Madrid', 2], ['Berlin', 3]]) %>
```

```html
<select name="person[city_id]" id="person_city_id">
  <option value="1">Lisbon</option>
  <option value="2" selected="selected">Madrid</option>
  <option value="3">Berlin</option>
</select>
```

Using the select helper

```erb
<%= form_with model: @person do |person_form| %>
  <%= person_form.select(:city_id, [['Lisbon', 1], ['Madrid', 2], ['Berlin', 3]]) %>
<% end %>

<%= form_with model: @person do |person_form| %>
  <%= person_form.select(:city_id) do %>
    <% [['Lisbon', 1], ['Madrid', 2], ['Berlin', 3]].each do |c| %>
      <%= content_tag(:option, c.first, value: c.last) %>
    <% end %>
  <% end %>
<% end %>
```

- If using `select` to set a `belongs_to` pass the foreign key, not the association itself
- When `:include_blank` or `:prompt` are not present, `:include_blank` is forced true if the select attribute required is true, display size is one, and multiple is not true.

### 03.3 Option Tags From a Collection of Arbitrary Objects

Use `options_from_collection_for_select`

```erb
<%= options_from_collection_for_select(City.all, :id, :name) %>
<%= collection_select(:person, :city_id, City.all, :id, :name) %>
<%= form_with model: @person do |person_form| %>
  <%= person_form.collection_select(:city_id, City.all, :id, :name) %>
<% end %>
```

- Pairs passed to options_for_select should have the text first and the value second, however with options_from_collection_for_select should have the value method first and the text method second.

### 03.4 Time Zone and Country Select

```erb
<%= time_zone_select(:person, :time_zone) %>
```

There is a country select plugin for countries

## 04 Using Date and Time Form Helpers

#### 04.1 Barebones Helpers

```erb
<%= select_date Date.today, prefix: :start_date %>
```

```html
<select id="start_date_year" name="start_date[year]">
</select>
<select id="start_date_month" name="start_date[month]">
</select>
<select id="start_date_day" name="start_date[day]">
</select>
```

### 04.2 Model Object Helpers

```erb
<%= date_select :person, :birth_date %>
```

```html
<select id="person_birth_date_1i" name="person[birth_date(1i)]">
</select>
<select id="person_birth_date_2i" name="person[birth_date(2i)]">
</select>
<select id="person_birth_date_3i" name="person[birth_date(3i)]">
</select>
```

### 04.3 Common Options

As a rule of thumb you should be using `date_select` when working with model objects and `select_date` in other cases, such as a search form which filters results by date.

### 04.4 Individual Components

Rails provides a series of helpers for this, one for each component `select_year`, `select_month`, `select_day`, `select_hour`, `select_minute`, and `select_second`.

## 05 Uploading Files

The most important thing to remember with file uploads is that the rendered form's enctype attribute must be set to "multipart/form-data"

```erb
<%= form_with(url: {action: :upload}, multipart: true) do %>
  <%= file_field_tag 'picture' %>
<% end %>

<%= form_with model: @person do |f| %>
  <%= f.file_field :picture %>
<% end %>
```

### 05.1 What Gets Uploaded

Files are saved in `#{Rails.root}/public/uploads`

## 06 Customizing Form Builders

You can customize the labels of forms

```erb
<%= form_with model: @person, builder: LabellingFormBuilder do |f| %>
  <%= f.text_field :first_name %>
<% end %>
```

```rb
class LabellingFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(attribute, options={})
    label(attribute) + super
  end
end
```

You could also turn this into a helper

```rb
def labeled_form_with(model: nil, scope: nil, url: nil, format: nil, **options, &block)
  options.merge! builder: LabellingFormBuilder
  form_with model: model, scope: scope, url: url, format: format, **options, &block
end
```

Form builder determines what happens when you do

```erb
<%= render partial: f %>
```

If `f` is an instance of `ActionView::Helpers::FormBuilder` then this will render the form partial, setting the partial's object to the form builder. If the form builder is of class `LabellingFormBuilder` then the `labelling_form` partial would be rendered instead.

## 07 Understanding Parameter Naming Conventions

The arrays and hashes you see in your application are the result of some parameter naming conventions that Rails uses.

