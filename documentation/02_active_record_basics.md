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

**Additional Features**
---
- `created_at` - Automatically gets set to the current date and time when the record is first created.
- `updated_at` - Automatically gets set to the current date and time whenever the record is updated.
- `lock_version` - Adds optimistic locking to a model.
- `type` - Specifies that the model uses Single Table Inheritance.
- `(association_name)_type` - Stores the type for polymorphic associations.
- `(table_name)_count` - Used to cache the number of belonging objects on associations. For example, a comments_count column in an Article class that has many instances of Comment will cache the number of existent comments for each article.



## 03 Creating Active Record Models
