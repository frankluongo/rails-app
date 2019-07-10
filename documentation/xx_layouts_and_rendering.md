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
