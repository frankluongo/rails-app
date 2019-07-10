# Layouts and Rendering in Rails

[This tutorial comes from Edge Guides](https://edgeguides.rubyonrails.org/layouts_and_rendering.html)

## 01 Overview: How the Pieces Fit Together

- This guide focuses on the relationship between the Controller and the view

## 02 Creating Responses

There are 3 ways to create an HTTP response from a controller

- Call `render` to build a full response and send it back to the browser
- Call `redirect_to` to send an HTTP redirect status code to the browser
- Call `head` to create a response solely consisting of HTTP Headers to send to the browser

### 02.1 Rendering by Default: Convention over Configuration in Action

Rails automagically renders view names that correspond with valid routes

Controller

```rb
class BooksController < ApplicationController
end
```

Routes

```rb
resources :books
```

Will automatically detect and display `app/views/books/index.html.erb`

Once we create our `books` model, we can add this to our controller to get a list of all books in our index

```rb
class BooksController < ApplicationController
  def index
    @books = Book.all
  end
end
```

We don't have to put a render in this method, it knows to just do it

### 02.2 Using Render

You can render out a whole host of things

#### 02.2.1 Rendering an Action's View

To render a view that corresponds to a different template within the same controller, do this:

```rb
def update
  @book = Book.find(params[:id])
  if @book.update(book_params)
    redirect_to(@book)
  else
    render "edit"
  end
end
```

If our call to update fails, we will fallback to rendering `edit`

Another way to write this using a symbol instead of a string:

```rb
def update
  @book = Book.find(params[:id])
  if @book.update(book_params)
    redirect_to(@book)
  else
    render :edit
  end
end
```

#### 02.2.2 Rendering an Action's Template From Another Controller

To render a template from another Controller:

```rb
render "products/show"
```

You can also use this for older versions of Rails

```rb
render template: "products/show"
```

#### 02.2.3 Rendering an Arbitrary File

You can also render a file outside of your app

```rb
render file: "/u/apps/warehouse_app/current/app/views/products/show"
```

#### 02.2.4 Wrapping it Up

Use the simplest render function for the code you are writing

#### 02.2.5 Using `render` with `:inline`

You can also render content straight from the controller in ERB or any other format. However, it should be avoided

```rb
render inline: "<% products.each do |p| %><p><%= p.name %></p><% end %>"

render inline: "xml.p {'Horrid coding practice!'}", type: :builder
```

#### 02.2.6 Rendering Text

```rb
render plain: "OK"
```

#### 02.2.7 Rendering HTML

```rb
render html: helpers.tag.strong('Not Found')
```

#### 02.2.8 Rendering JSON

```rb
render json: @product
```

#### 02.2.9 Rendering XML

```rb
render xml: @product
```

#### 02.2.10 Rendering JavaScript

```rb
render js: "alert('Hello Rails');"
```

#### 02.2.11 Rendering Raw Body

This is just raw content sent to the browser

```rb
render body: "raw"
```

#### 02.2.12 Options for `render`

Calls to Render accept these 6 options

- `:content_type`
- `:layout`
- `:location`
- `:status`
- `:formats`
- `:variants`

##### 02.2.12.1 The `:content_type` Option

```rb
render file: filename, content_type: "application/rss"
```

##### 02.2.12.2 The `:layout` Option

```rb
render layout: "special_layout"
render layout: false
```

##### 02.2.12.3 The `:location` Option

Set the location option for the HTTP Header

```rb
render xml: photo, location: photo_url(photo)
```

##### 02.2.12.4 The `:status` Option

Manually change the status provided by the response

```rb
render status: 500
render status: :forbidden
```

##### 02.2.12.5 The `:formats` Option

Change the formats the response is sent in

```rb
render formats: :xml
render formats: [:json, :xml]
```

##### 02.2.12.6 The `:variants` Option

Tell Rails to look for variants of a certain template type

```rb
render variants: [:mobile, :desktop]
```

Template Names it will look for:

- app/views/home/index.html+mobile.erb
- app/views/home/index.html+desktop.erb
- app/views/home/index.html.erb

Variants can also be called in the request

```rb
def index
  request.variant = determine_variant
end

private

def determine_variant
  variant = nil
  # some code to determine the variant(s) to use
  variant = :mobile if session[:use_mobile]

  variant
end
```

#### 02.2.13 Finding Layouts

Rails goes through a couple of locations to find the right layout

##### 02.2.13.1 Specifying Layouts for Controllers

```rb
class ProductsController < ApplicationController
  layout "inventory"
  #...
end
```

To assign a specific layout for the whole application...

```rb
class ApplicationController < ActionController::Base
  layout "main"
  #...
end
```

##### 02.2.13.2 Choosing Layouts at Runtime

You can use a symbol to defer layout choice until Runtime

```rb
class ProductsController < ApplicationController
  layout :products_layout

  def show
    @product = Product.find(params[:id])
  end

  private
    def products_layout
      @current_user.special? ? "special" : "products"
    end
end
```

You can also use the `Proc` Object

```rb
class ProductsController < ApplicationController
  layout Proc.new { |controller| controller.request.xhr? ? "popup" : "application" }
end
```

##### 02.2.13.3 Conditional Layouts

Laouts in the controller support `:only` and `:except` options.

```rb
class ProductsController < ApplicationController
  layout "product", except: [:index, :rss]
end
```

For this example, the `product` layout would be used for everything but the RSS and index pages

##### 02.2.13.4 Layout Inheritance

Layout inheritance cascades down, similar to CSS

##### 02.2.13.5 Template Inheritance

```rb
# in app/controllers/application_controller
class ApplicationController < ActionController::Base
end

# in app/controllers/admin_controller
class AdminController < ApplicationController
end

# in app/controllers/admin/products_controller
class Admin::ProductsController < AdminController
  def index
  end
end
```

The lookup order will be

- app/views/admin/products/
- app/views/admin/
- app/views/application/

Therefore, you should store shared partials in `app/views/application/`

#### 02.2.14 Avoiding Double Render Errors

Avoid double renders like this

```rb
def show
  @book = Book.find(params[:id])
  if @book.special?
    render action: "special_show" and return
  end
  render action: "regular_show"
end
```

This can also be accomplished like this

```rb
def show
  @book = Book.find(params[:id])
  if @book.special?
    render action: "special_show"
  end
end
```

### 02.3 Using `redirect_to`

This sends the user to a different URL

```rb
redirect_to photos_url
```

You can also redirect back to where the user just came from

```rb
redirect_back(fallback_location: root_path)
```

#### 02.3.2 The Difference Between `render` and `redirect_to`

You should only use `redirect_to` if you want to make a new request and send the user somewhere else

```rb
def index
  @books = Book.all
end

def show
  @book = Book.find_by(id: params[:id])
  if @book.nil?
    @books = Book.all
    flash.now[:alert] = "Your book was not found"
    render "index"
  end
end
```

### 02.4 Using `head` To Build Header-Only Responses

This is way to send responses with only headers to the browser

```rb
head :bad_request
```

You can also use it to send other information

```rb
head :created, location: photo_path(@photo)
```

Creates

```text
HTTP/1.1 201 Created
Connection: close
Date: Sun, 24 Jan 2010 12:16:44 GMT
Transfer-Encoding: chunked
Location: /photos/1
Content-Type: text/html; charset=utf-8
X-Runtime: 0.083496
Set-Cookie: _blog_session=...snip...; path=/; HttpOnly
Cache-Control: no-cache
```

## 03 Structuring Layouts

You have three tools for combining different bits of output: Asst Tags, `yield` and `content_for` and partials

### 03.1 Asset Tag Helpers

These provide methods for generating HTML that link views to feeds. There are six tags available

- auto_discovery_link_tag
- javascript_include_tag
- stylesheet_link_tag
- image_tag
- video_tag
- audio_tag

#### 03.1.1 Linking Feeds with `auto_discovery_link_tag`

This is for RSS feeds

```erb
<%= auto_discovery_link_tag(:rss, {action: "feed"},
  {title: "RSS Feed"}) %>
```

There are three options for this.

- `:rel` specifies the rel value in the link
- `:type` specifies the explicit MIME type.
- `:title` specifies the title of the link.

#### 03.1.2 Linking to JavaScript Files with the `javascript_include_tag`

Returns an HTML Script tag for each source provided

```erb
<%= javascript_include_tag "main" %>

<%= javascript_include_tag "main", "columns" %>

<%= javascript_include_tag "main", "/photos/columns" %>

<%= javascript_include_tag "http://example.com/main.js" %>
```

#### 03.1.3 Linking to CSS Files With The `stylesheet_link_tag`

Returns a link to CSS

```erb
<%= stylesheet_link_tag "main" %>

<%= stylesheet_link_tag "main", "columns" %>

<%= stylesheet_link_tag "main", "photos/columns" %>

<%= stylesheet_link_tag "http://example.com/main.css" %>

<%= stylesheet_link_tag "main_print", media: "print" %>
```

#### 03.1.4 Linking to Images with the `image_tag`

You MUST specify an extension

```erb
<%= image_tag "header.png" %>

<%= image_tag "icons/delete.gif" %>

<%= image_tag "icons/delete.gif", {height: 45} %>

<%= image_tag "home.gif", size: "50x20" %>

<%= image_tag "home.gif", alt: "Go Home",
                          id: "HomeImage",
                          class: "nav_bar" %>
```

#### 03.1.5 Linking Videos With The `video_tag`

These can take similar attributes to the `image_tag`

```erb
<%= video_tag "movie.ogg" %>
<%= video_tag ["trailer.ogg", "movie.ogg"] %>
```

#### 03.1.6 Linking to Audio Files with The `audio_tag`

```erb
<%= audio_tag "music.mp3" %>
<%= audio_tag "music/first_song.mp3" %>
```

There are some special properties that apply to this and the video tag

- `autoplay:` true, starts playing the audio on page load
- `controls:` true, provides browser supplied controls for the user to interact with the audio.
- `autobuffer:` true, the audio will pre load the file for the user on page load.

### 03.2 Understanding `yield`
