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

### 07.1 Basic Structures

- Arrays and Hashes
- Hashes mirror the syntax used for accessing the value in params

For Hashes...

```html
<input id="person_name" name="person[name]" type="text" value="Henry"/>
```

Will be

```rb
{'person' => {'name' => 'Henry'}}
```

and `params[:person][:name]` will retrieve the submitted value in the controller.

Hashes can be nested as much as needed

```html
<input id="person_address_city" name="person[address][city]" type="text" value="New York"/>
```

```rb
{'person' => {'address' => {'city' => 'New York'}}}
```

This is how to add an array

```html
<input name="person[phone_number][]" type="text"/>
<input name="person[phone_number][]" type="text"/>
<input name="person[phone_number][]" type="text"/>
```

This would result in `params[:person][:phone_number]` being an array containing the inputted phone numbers.

### 07.2 Combining Arrays and Hashes

```html
<input name="person[addresses][][line1]" type="text"/>
<input name="person[addresses][][line2]" type="text"/>
<input name="person[addresses][][city]" type="text"/>
<input name="person[addresses][][line1]" type="text"/>
<input name="person[addresses][][line2]" type="text"/>
<input name="person[addresses][][city]" type="text"/>
```

This would result in `params[:person][:addresses]` being an array of hashes with keys `line1`, `line2`, and `city`.

- There can only be one level or an array
- Array parameters do not play well with the check_box helper. According to the HTML specification unchecked checkboxes submit no value. However it is often convenient for a checkbox to always submit a value. The check_box helper fakes this by creating an auxiliary hidden input with the same name. If the checkbox is unchecked only the hidden input is submitted and if it is checked then both are submitted but the value submitted by the checkbox takes precedence.

### 07.3 Using Form Helpers

All of that is nice, but here's how to do it with helpers

Input:

```erb
<%= form_with model: @person do |person_form| %>
  <%= person_form.text_field :name %>
  <% @person.addresses.each do |address| %>
    <%= person_form.fields_for address, index: address.id do |address_form| %>
      <%= address_form.text_field :city %>
    <% end %>
  <% end %>
<% end %>
```

Output:

```html
<form accept-charset="UTF-8" action="/people/1" data-remote="true" method="post">
  <input name="_method" type="hidden" value="patch" />
  <input id="person_name" name="person[name]" type="text" />
  <input id="person_address_23_city" name="person[address][23][city]" type="text" />
  <input id="person_address_45_city" name="person[address][45][city]" type="text" />
</form>
```

Resulting Params:

```rb
{'person' => {'name' => 'Bob', 'address' => {'23' => {'city' => 'Paris'}, '45' => {'city' => 'London'}}}}
```

You can be even more specific:

```erb
<%= fields_for 'person[address][primary]', address, index: address.id do |address_form| %>
  <%= address_form.text_field :city %>
<% end %>
```

```html
<input id="person_address_primary_1_city" name="person[address][primary][1][city]" type="text" value="Bologna" />
```

As a general rule the final input name is the concatenation of the name given to fields_for/form_with, the index value, and the name of the attribute

As a shortcut you can append [] to the name and omit the `:index` option. This is the same as specifying `index: address.id` so...

```erb
<%= fields_for 'person[address][primary][]', address do |address_form| %>
  <%= address_form.text_field :city %>
<% end %>
```

## 08 Forms to External Resources

You may need to add an auth token

```erb
<%= form_with url: 'http://farfar.away/form', authenticity_token: 'external_token' do %>
  Form contents
<% end %>
```

How not to add an auth token...

```erb
<%= form_with url: 'http://farfar.away/form', authenticity_token: false do %>
  Form contents
<% end %>
```

## 09 Building Complex Forms

### 09.1 Configuring The Model

Allow editing via the model

```rb
class Person < ApplicationRecord
  has_many :addresses, inverse_of: :person
  accepts_nested_attributes_for :addresses
end

class Address < ApplicationRecord
  belongs_to :person
end
```

This creates an `addresses_attributes=` method on `Person` that allows you to create, update, and (optionally) destroy addresses.

### 09.2 Nested Forms

```erb
<%= form_with model: @person do |f| %>
  Addresses:
  <ul>
    <%= f.fields_for :addresses do |addresses_form| %>
      <li>
        <%= addresses_form.label :kind %>
        <%= addresses_form.text_field :kind %>

        <%= addresses_form.label :street %>
        <%= addresses_form.text_field :street %>
        ...
      </li>
    <% end %>
  </ul>
<% end %>
```

When an association accepts nested attributes fields_for renders its block once for every element of the association. In particular, if a person has no addresses it renders nothing.

```rb
def new
  @person = Person.new
  2.times { @person.addresses.build }
end
```

The fields_for yields a form builder. The parameters' name will be what accepts_nested_attributes_for expects. For example, when creating a user with 2 addresses, the submitted parameters would look like:

```rb
{
  'person' => {
    'name' => 'John Doe',
    'addresses_attributes' => {
      '0' => {
        'kind' => 'Home',
        'street' => '221b Baker Street'
      },
      '1' => {
        'kind' => 'Office',
        'street' => '31 Spooner Street'
      }
    }
  }
}
```

The keys of the :addresses_attributes hash are unimportant, they need merely be different for each address.

If the associated object is already saved, fields_for autogenerates a hidden input with the  id of the saved record. You can disable this by passing include_id: false to fields_for.

### 09.3 The Controller

Declare the permitted parameters

```rb
def create
  @person = Person.new(person_params)
  # ...
end

private
  def person_params
    params.require(:person).permit(:name, addresses_attributes: [:id, :kind, :street])
  end
```

### 09.4 Removing Objects

You can allow users to delete associated objects by passing allow_destroy: true to accepts_nested_attributes_for

```rb
class Person < ApplicationRecord
  has_many :addresses
  accepts_nested_attributes_for :addresses, allow_destroy: true
end
```

If the hash of attributes for an object contains the key _destroy with a value that evaluates to true (eg. 1, '1', true, or 'true') then the object will be destroyed. This form allows users to remove addresses:

```erb
<%= form_with model: @person do |f| %>
  Addresses:
  <ul>
    <%= f.fields_for :addresses do |addresses_form| %>
      <li>
        <%= addresses_form.check_box :_destroy %>
        <%= addresses_form.label :kind %>
        <%= addresses_form.text_field :kind %>
        ...
      </li>
    <% end %>
  </ul>
<% end %>
```

Don't forget to update the permitted params in your controller to also include the _destroy field:

```rb
def person_params
  params.require(:person).
    permit(:name, addresses_attributes: [:id, :kind, :street, :_destroy])
end
```

### 09.5 Preventing Empty Records

It is often useful to ignore sets of fields that the user has not filled in. You can control this by passing a :reject_if proc to accepts_nested_attributes_for. This proc will be called with each hash of attributes submitted by the form. If the proc returns false then Active Record will not build an associated object for that hash. The example below only tries to build an address if the kind attribute is set.

```rb
class Person < ApplicationRecord
  has_many :addresses
  accepts_nested_attributes_for :addresses, reject_if: lambda {|attributes| attributes['kind'].blank?}
end
```

As a convenience you can instead pass the symbol :all_blank which will create a proc that will reject records where all the attributes are blank excluding any value for _destroy.


### 09.6 Adding Fields on The Fly

When generating new sets of fields you must ensure the key of the associated array is unique - the current JavaScript date (milliseconds since the epoch) is a common choice.

## 10 Using form_for and form_tag

Before form_with was introduced in Rails 5.1 its functionality used to be split between form_tag and form_for. Both are now soft-deprecated.

