# Active Record Migrations

## 01 Migration Overview
Example
```rb
class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
```

Tell Active Record how to reverse a migration manually
```rb
class ChangeProductsPrice < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      change_table :products do |t|
        dir.up   { t.change :price, :string }
        dir.down { t.change :price, :integer }
      end
    end
  end
end
```

You can also use `down` instead of `change`
```rb
class ChangeProductsPrice < ActiveRecord::Migration[5.0]
  def up
    change_table :products do |t|
      t.change :price, :string
    end
  end

  def down
    change_table :products do |t|
      t.change :price, :integer
    end
  end
end
```



## 02 Creating a Migration

### 02.1 Creating a Standalone Migration
- File name is like this `YYYYMMDDHHMMSS_create_products.rb`
- Migration class should match the name of the migration

Generate a migration
```
bin/rails generate migration AddPartNumberToProducts
```
Creates this
```rb
class AddPartNumberToProducts < ActiveRecord::Migration[5.0]
  def change
  end
end
```

If the migration contains "Add" or "Remove" in its name, Rails will build it appropriately
```
bin/rails generate migration AddPartNumberToProducts part_number:string
```
Creates
```rb
class AddPartNumberToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :part_number, :string
  end
end
```

Add an index to a new column
```
bin/rails generate migration AddPartNumberToProducts part_number:string:index
```

```rb
class AddPartNumberToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :part_number, :string
    add_index :products, :part_number
  end
end
```

Remove a migration
```
bin/rails generate migration RemovePartNumberFromProducts part_number:string
```

Creates
```rb
class RemovePartNumberFromProducts < ActiveRecord::Migration[5.0]
  def change
    remove_column :products, :part_number, :string
  end
end
```

Create multiple columns with one command
```
bin/rails generate migration AddDetailsToProducts part_number:string price:decimal
```

```rb
class AddDetailsToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :part_number, :string
    add_column :products, :price, :decimal
  end
end
```

The name "Create" will make a table
```
bin/rails generate migration CreateProducts name:string part_number:string
```
Makes
```rb

class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :part_number
    end
  end
end
```

You can also add column types `references` and `belongs_to`
```
bin/rails generate migration AddUserRefToProducts user:references
```

```rb
class AddUserRefToProducts < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :user, foreign_key: true
  end
end
```

You can also create a join table
```
bin/rails g migration CreateJoinTableCustomerProduct customer product
```

```rb

class CreateJoinTableCustomerProduct < ActiveRecord::Migration[5.0]
  def change
    create_join_table :customers, :products do |t|
      # t.index [:customer_id, :product_id]
      # t.index [:product_id, :customer_id]
    end
  end
end
```


### 02.2 Model Generators
```
bin/rails generate model Product name:string description:text
```
Creates this migration
```rb

class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
```


### 02.3 Passing Modifiers
```
bin/rails generate migration AddDetailsToProducts 'price:decimal{5,2}' supplier:references{polymorphic}
```

```rb
class AddDetailsToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :price, :decimal, precision: 5, scale: 2
    add_reference :products, :supplier, polymorphic: true
  end
end
```



## 03 Writing a Migration

### 03.1 Creating a Table

```rb
create_table :products do |t|
  t.string :name
end
```

You can also append options to this
```rb
create_table :products, options: "ENGINE=BLACKHOLE" do |t|
  t.string :name, null: false
end
```

### 03.2 Creating a Join Table
To create tables that join two other tables...
```rb
create_join_table :products, :categories
```

To specify Null
```rb
create_join_table :products, :categories, column_options: { null: true }
```

For a custom name
```rb
create_join_table :products, :categories, table_name: :categorization
```

To create a table with custom indeces
```rb
create_join_table :products, :categories do |t|
  t.index :product_id
  t.index :category_id
end
```


### 03.3 Changing Tables
To change existing Tables
```rb
change_table :products do |t|
  t.remove :description, :name
  t.string :part_number
  t.index :part_number
  t.rename :upccode, :upc_code
end
```


### 03.4 Changing Columns
To change the value a column accepts...
```rb
change_column :products, :part_number, :text
```
Note that this is irreversible

Additional Column Changes
```rb
change_column_null :products, :name, false
change_column_default :products, :approved, from: true, to: false
```


### 03.5 Column Modifiers
- `limit` Sets the maximum size of the string/text/binary/integer fields.
- `precision` Defines the precision for the decimal fields, representing the total number of digits in the number.
- `scale` Defines the scale for the decimal fields, representing the number of digits after the decimal point.
- `polymorphic` Adds a type column for belongs_to associations.
- `null` Allows or disallows NULL values in the column.
- `default` Allows to set a default value on the column. Note that if you are using a dynamic value (such as a date), the default will only be
- `calculated` the first time (i.e. on the date the migration is applied).
- `index` Adds an index for the column.
- `comment` Adds a comment for the column.


### 03.6 Foreign Keys
These guarantee referntial integrity!
```rb
add_foreign_key :articles, :authors
```
This adds a new foreign key to the `author_id` column of the `articles` table. The key references the ID of the `authors` table.

To remove foreign keys
```rb
# let Active Record figure out the column name
remove_foreign_key :accounts, :branches

# remove foreign key for a specific column
remove_foreign_key :accounts, column: :owner_id

# remove foreign key by name
remove_foreign_key :accounts, name: :special_fk_name
```


### 03.7 When Helpers Aren't Enough
To just go ahead and execute some SQL
```rb
Product.connection.execute("UPDATE products SET price = 'free' WHERE 1=1")
```


### 03.8 Using the `change` Method
Change supports the following methods
```
add_column
add_foreign_key
add_index
add_reference
add_timestamps
change_column_default (must supply a :from and :to option)
change_column_null
create_join_table
create_table
disable_extension
drop_join_table
drop_table (must supply a block)
enable_extension
remove_column (must supply a type)
remove_foreign_key (must supply a second table)
remove_index
remove_reference
remove_timestamps
rename_column
rename_index
rename_table
```
- It is also reversible
- `remove_column` is irreversible


### 03.9 Using `reversible`
For complex migrations, state how to reverse it
```rb
class ExampleMigration < ActiveRecord::Migration[5.0]
  def change
    create_table :distributors do |t|
      t.string :zipcode
    end

    reversible do |dir|
      dir.up do
        # add a CHECK constraint
        execute <<-SQL
          ALTER TABLE distributors
            ADD CONSTRAINT zipchk
              CHECK (char_length(zipcode) = 5) NO INHERIT;
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE distributors
            DROP CONSTRAINT zipchk
        SQL
      end
    end

    add_column :users, :home_page_url, :string
    rename_column :users, :email, :email_address
  end
end
```
This ensures that instructions are executed in the right order.


### 03.10 Using The Up/Down Methods
The old school way!

```rb
class ExampleMigration < ActiveRecord::Migration[5.0]
  def up
    create_table :distributors do |t|
      t.string :zipcode
    end

    # add a CHECK constraint
    execute <<-SQL
      ALTER TABLE distributors
        ADD CONSTRAINT zipchk
        CHECK (char_length(zipcode) = 5);
    SQL

    add_column :users, :home_page_url, :string
    rename_column :users, :email, :email_address
  end

  def down
    rename_column :users, :email_address, :email
    remove_column :users, :home_page_url

    execute <<-SQL
      ALTER TABLE distributors
        DROP CONSTRAINT zipchk
    SQL

    drop_table :distributors
  end
end
```


### 03.11 Reverting a Previous Migration
```rb
require_relative '20121212123456_example_migration'

class FixupExampleMigration < ActiveRecord::Migration[5.0]
  def change
    revert ExampleMigration

    create_table(:apples) do |t|
      t.string :variety
    end
  end
end
```

```rb
class DontUseConstraintForZipcodeValidationMigration < ActiveRecord::Migration[5.0]
  def change
    revert do
      # copy-pasted code from ExampleMigration
      reversible do |dir|
        dir.up do
          # add a CHECK constraint
          execute <<-SQL
            ALTER TABLE distributors
              ADD CONSTRAINT zipchk
                CHECK (char_length(zipcode) = 5);
          SQL
        end
        dir.down do
          execute <<-SQL
            ALTER TABLE distributors
              DROP CONSTRAINT zipchk
          SQL
        end
      end

      # The rest of the migration was ok
    end
  end
end
```


## 04 Running Migrations
To specify a version
```
bin/rails db:migrate VERSION=20080906120000
```

### 04.1 Rolling Back
Rollback last migration
```
bin/rails db:rollback
```

Roll back the last 3 migrations
```
bin/rails db:rollback STEP=3
```


### 04.2 Setup The Database
Create the database, load the schema and initialize it
```
db:setup
```


### 04.3 Resetting The Database
Drop the database and set it up again
```
db:reset
```


### 04.4 Running Specific Migrations
```
bin/rails db:migrate:up VERSION=20080906120000
```


### 04.5 Running Migrations in Different Environments
```
bin/rails db:migrate RAILS_ENV=test
```


### 04.6 Chaning the Output of Running Migrations
you can use `suppress_messages`, `say` and `say_with_time` to add custom messages to migrations




## 05 Changing Existing Migrations
You *can* re-run existing migrations by doing a rollback and then calling them again but it is not recommended




## 06 Schema Dumping And You

### 06.1 What Are Schema Files For?
These files sum up the database schema in one place


### 06.2 Types of Schema Dumps
They can either be in `sql` or `ruby`


### 06.3 Schema Dumps and Source Control
Keep them in git




## 07 Active Record and Referential Integrity
Active Record does validation but it's up to you to keep up the integrity of your DB




## 08 Migrations and Seed Data
Adding Initial Seed Data with a migration
```rb
class AddInitialProducts < ActiveRecord::Migration[5.0]
  def up
    5.times do |i|
      Product.create(name: "Product ##{i}", description: "A product.")
    end
  end

  def down
    Product.delete_all
  end
end
```

```rb
5.times do |i|
  Product.create(name: "Product ##{i}", description: "A product.")
end
```
