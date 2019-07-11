# Active Record Basics

## 01 What is Active Record

- The "M" in MVC

### 01.1 The Active Record Pattern

- Defined by Martin Fowler
- Objects carry both persistent data and behavior which operates on that data

### 01.2 Object Relational Mapping

- ORM connects rich objects of an application to relational database management systems

### 01.3 Active Record as an ORM Framework

- Represent models and their data.
- Represent associations between these models.
- Represent inheritance hierarchies through related models.
- Validate models before they get persisted to the database.
- Perform database operations in an object-oriented fashion.

## 02 Convention Over Configuration in Active Record

### 02.1 Naming Conventions

- Rails will **pluralize** class names to find the corresponding database table.
  - i.e.) the class `Book` will refer to the database table called `books`
- CamelCase will be converted to underscores for the database table

### 02.2 Schema Conventions

- **Foreign Keys:** Use the pattern `singularized_table_name_id` (`item_id` or `order_id`).
  - These are the fields active record will look for when creating associations between the models
- **Primary Keys:** Active Record automatically created an ID column to use as a primary key

#### Additional Features

---

- `created_at` - Automatically gets set to the current date and time when the record is first created.
- `updated_at` - Automatically gets set to the current date and time whenever the record is updated.
- `lock_version` - Adds optimistic locking to a model.
- `type` - Specifies that the model uses Single Table Inheritance.
- `(association_name)_type` - Stores the type for polymorphic associations.
- `(table_name)_count` - Used to cache the number of belonging objects on associations. For example, a comments_count column in an Article class that has many instances of Comment will cache the number of existent comments for each article.

## 03 Creating Active Record Models

Create a model called `product.rb`

```rb
class Product < ApplicationRecord
end
```

This model is now mapped to the `products` table in the database

Let's say the `products` table was created like this...

```sql
CREATE TABLE products (
   id int(11) NOT NULL auto_increment,
   name varchar(255),
   PRIMARY KEY  (id)
);
```

This means the `products` table had an ID and name. ID is an integer, auto increments and later is signified as the primary key for identifying things in this table. String is a character limited to 255 characters

Then you can write code like this...

```rb
p = Product.new
p.name = "Some Book"
puts p.name # "Some Book"
```

## 04 Overriding the Naming Conventions

It is possible to override Active Record defaults

Here we override the table associated with this Active Record

```rb
class Product < ApplicationRecord
  self.table_name = "my_products"
end
```

If you do, you will have to manually define the class name hosting the fixtures for tests

```rb
class ProductTest < ActiveSupport::TestCase
  set_fixture_class my_products: Product
  fixtures :my_products
  ...
end
```

You can also override the primary key

```rb
class Product < ApplicationRecord
  self.primary_key = "product_id"
end
```

## 05 CRUD: Reading & Writing Data

### 05.1 Create

- The `new` method returns a new object without saving it to the database.
- `create` returns the object AND saves it to the database
- To save something created with `new`, use the `save` method

```rb
# Create a user and save them to the db
user = User.create(name: "David", occupation: "Code Artist")

# Just create a user
user = User.new
user.name = "David"
user.occupation = "Code Artist"

# save them
user.save
```

Provide a block to bind a new object to it during initialization

```rb
user = User.new do |u|
  u.name = "David"
  u.occupation = "Code Artist"
end
```

### 05.2 Read

[Learn More In This Guide](https://guides.rubyonrails.org/active_record_querying.html)

Basic Commands

```rb
# return a collection with all users
users = User.all
# return the first user
user = User.first
# return the first user named David
david = User.find_by(name: 'David')
# find all users named David who are Code Artists and sort by created_at in reverse chronological order
users = User.where(name: 'David', occupation: 'Code Artist').order(created_at: :desc)
```

### 05.3 Update

Once we have am object, we can update it and save it to the database

```rb
user = User.find_by(name: 'David')
user.name = 'Dave'
user.save
```

A shorthand with hash matching

```rb
user = User.find_by(name: 'David')
user.update(name: 'Dave')
```

To update several attributes at once

```rb
User.update_all "max_login_attempts = 3, must_change_password = 'true'"
```

### 05.4 Delete

Destroy one

```rb
user = User.find_by(name: 'David')
user.destroy
```

Destroy All

```rb
# find and delete all users named David
User.where(name: 'David').destroy_all

# delete all users
User.destroy_all
```

## 06 Validations

Active Record provides plenty of built-in validations

```rb
class User < ApplicationRecord
  validates :name, presence: true
end

user = User.new
user.save  # => false
user.save! # => ActiveRecord::RecordInvalid: Validation failed: Name can't be blank
```

Using `!` will cause an error

## 07 Callbacks

There's a whole guide on this

## 08 Migrations

Rails provides an easy way to perform migrations

```rb
class CreatePublications < ActiveRecord::Migration[5.0]
  def change
    create_table :publications do |t|
      t.string :title
      t.text :description
      t.references :publication_type
      t.integer :publisher_id
      t.string :publisher_type
      t.boolean :single_issue

      t.timestamps
    end
    add_index :publications, :publication_type_id
  end
end
```

Run a Migration

```bash
rails db:migrate
```

Rollback a Migration

```bash
rails db:rollback
```
