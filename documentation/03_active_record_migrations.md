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
