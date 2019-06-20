# [Getting Started](https://guides.rubyonrails.org/getting_started.html)

## 03 Creating a New Rails Project
Check for all the things you need
```
ruby -v
rails --version
```

Don't have something? Install it
```
gem install rails
```

### 03.2 Making Your Project
```
rails new project-name
```


## 04 Hello, Rails!

### 04.1 Starting The Server

```
bin/rails server
```

### 04.2 Generating A Controller
```
bin/rails generate controller Welcome index
```

### 04.3 Setting Routes
Go to `config/routes.rb` to set up the routes for your application

Run this command to see all routes
```
bin/rails routes
```


### 04.4 Resources
- Resources are a collection of similar objects. They can be created, read, updated and destroyed (CRUD).
- By default, Rails expects `new` and `create` actions in the controller for these to work


### 04.5 Models
- Models in Rails use a singular name
- Their corresponding database tables use a plural name


### 04.6 Migrations
```
bin/rails db:migrate
```

## 05 CRUD

### 5.11 Updating Articles
- Add an `edit` and `update` functions in the article controller
- Add an update form to the `edit` page

### 5.12 Using Partials
- We create a partial called `_form.html.erb` and import it on the new and edit pages

### 5.13 Deleting Articles
- We don't make a `get` route for deleting an article because that could be bad


## 06 Adding a Second Model

### 6.1 Generating a Model
```
bin/rails generate model Comment commenter:string body:text article:references
```

### 6.2 Associating Models

In `app/models/article.rb`
```rb
class Article < ApplicationRecord
  has_many :comments
  validates :title, presence: true,
                    length: { minimum: 5 }
end
```


### 6.3 Adding a Route for Comments
Add a route for comments to live in

In `routes.rb`
```rb
resources :articles do
  resources :comments
end
```

### 6.4 Generating a Controller
```
bin/rails generate controller Comments
```

After creating the controller, we build the appropriate actions for adding comments in `comments_controller.rb`
```rb
class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end

  private
    def comment_params
      params.require(:comment).permit(:commenter, :body)
    end
end
```



## 07 Refactoring

### 7.1 Rendering Partial Collections
Create file `app/views/comments/_comment.html.erb`
```html
<p>
  <strong>Commenter:</strong>
  <%= comment.commenter %>
</p>

<p>
  <strong>Comment:</strong>
  <%= comment.body %>
</p>
```

### 7.2 Rendering a Partial Form
Create file `app/views/comments/_form.html.erb`
```html
<%= form_with(model: [ @article, @article.comments.build ], local: true) do |form| %>
  <p>
    <%= form.label :commenter %><br>
    <%= form.text_field :commenter %>
  </p>
  <p>
    <%= form.label :body %><br>
    <%= form.text_area :body %>
  </p>
  <p>
    <%= form.submit %>
  </p>
<% end %>
```



## 08 Deleting Comments
In `app/views/comments/_comment.html.erb`
```html

<p>
  <strong>Commenter:</strong>
  <%= comment.commenter %>
</p>

<p>
  <strong>Comment:</strong>
  <%= comment.body %>
</p>

<p>
  <%= link_to 'Destroy Comment', [comment.article, comment],
               method: :delete,
               data: { confirm: 'Are you sure?' } %>
</p>
```

### 8.1 Deleting Associated Objects
When you delete an article, delete it's comments! In `app/models/article.rb`
```rb
class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  validates :title, presence: true,
                    length: { minimum: 5 }
end
```



## 09 Security

### 09.1 Basic Authentication
In `articles_controller.rb`
```rb
http_basic_authenticate_with name: "dhh", password: "secret", except: [:index, :show]
```

and `comments_controller.rb`
```
http_basic_authenticate_with name: "dhh", password: "secret", only: :destroy
```

- Two popular authentication methods are [Devise](https://github.com/plataformatec/devise) and [AuthLogic](https://github.com/binarylogic/authlogic)

