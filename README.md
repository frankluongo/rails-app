# Rails Application

## [Getting Started](https://guides.rubyonrails.org/getting_started.html)

### Installing Ruby and Rails
Check for all the things you need
```
ruby -v
rails --version
```

Don't have something? Install it
```
gem install rails
```

### Making Your Project
```
rails new project-name
```


### Starting The Server

```
bin/rails server
```

### Generating A Controller
```
bin/rails generate controller Welcome index
```

### Setting Routes
Go to `config/routes.rb` to set up the routes for your application

Run this command to see all routes
```
bin/rails routes
```


### Resources
- Resources are a collection of similar objects. They can be created, read, updated and destroyed (CRUD).
- By default, Rails expects `new` and `create` actions in the controller for these to work


### Models
- Models in Rails use a singular name
- Their corresponding database tables use a plural name


### Migrations
```
bin/rails db:migrate
```


### 5.11 Updating Articles
- Add an `edit` and `update` functions in the article controller
- Add an update form to the `edit` page

### 5.12 Using Partials
- We create a partial called `_form.html.erb` and import it on the new and edit pages

### 5.13 Deleting Articles
- We don't make a `get` route for deleting an article because that could be bad
