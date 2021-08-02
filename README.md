


Active Record :  
-----
#### has_many <---> belongs_to
In the Demo project we are exploring the associative relationship between two models where: \
`Author` **has_many :books** and a `Book` **belongs_to :author** \
Here both the *Book* and *Author* are models that have a bi-directional relationship that will be explored.

Here is what the two models will look like initially when creating from scratch:
```ruby
class Author < ApplicationRecord 
end

class Book < ApplicationRecord
 belongs_to :author
end
```

### 1. Quick Setup

```
git clone https://github.com/cabrace/belongs_to.git
cd active-record-belongs_to
yarn install
rails db:migrate
rails db:seed 
rails s 
```
The above clones the application, installs JS packages, migrates the DB, seeds the DB and then runs the server
go to -->  http://localhost:3000 and test the has_many belongs_to functionality.


### 2. Create from Scratch

1. Create project skipping Action Mailer(-M) and Testing(-T)
2. Generate the `Book` model along with assosciated scaffolding  
3. Generate the `Author` model along with associated scaffolding
4. Add the necessary relations in the `Model`
5. Update the `views` accordingly

#### 2.1 Setup the Project folder and generate a few Models from Scaffolding
```
rails new belongs_to -M -T 
```
#### 2.2 Generate the Scaffold for the entire MVC setup.
```
rails g scaffold Book title:string author:references 
rails g scaffold Author name:string
```
This scaffolding section does a lot of stuff for us, but primarily here we are just focused on the `Book` model which has a reference to `Author`,
and the `Author` just has a name field for a column, which is of type string.

#### 2.3 Edit the Model files to create the bi-drirectional associative relationship between them:

```ruby
# /app/models/author.rb
class Author < ApplicationRecord 
 has_many :books, dependent: :destroy
end

# /app/models/book.rb
class Book < ApplicationRecord
 belongs_to :author
end
```
Generally any model that has a `belongs_to` section, also has a Foreign Key(FK) from the table it belongs to in it as a reference.  
So here the `Book` model has an **:author_id** as a FK in its table in the DB.

#### 2.4. Edit the View files to make it easier to add data from one model or another:

```erb
<!-- /app/views/books/_form.html.erb -->
...
  <!-- REMOVE THIS -->
  <div class="field">
    <%= form.label :author_id %>
    <%= form.text_field :author_id %>
  </div>
...
```
```erb
<!-- /app/views/books/_form.html.erb -->
...
<!-- REPLACE WITH -->
  <div class="field">
    <%= form.collection_select :author_id, Author.order(:name), :id, :name %>
  </div>
...
```
#### 2.5 (Complete form)

```erb
<!-- /app/views/books/_form.html.erb -->
<%= form_with(model: book) do |form| %>
  <% if book.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(book.errors.count, "error") %> prohibited this book from being saved:</h2>

      <ul>
        <% book.errors.each do |error| %>
          <li><%= error.full_message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <!--Added-->
  <div class="field">
    <%= form.collection_select :author_id, Author.order(:name), :id, :name %>
  </div>

  <div class="field">
    <%= form.label :title %>
    <%= form.text_field :title %>
  </div>

  <div class="actions">
    <%= form.submit %>
  </div>
<% end %>
```
Doing the above will allow us to **SELECT** from a list of Authors already entered on the author_create path.  
That's all that must be done in order to attach a dropdown select of an Author on a Book-View.  
From here make sure the DB is migrated with the following and start the server. 

```
rails:db:migrate
rails s
```

Understanding
----
Note here the direction of the association of using an already existing `author_id` being attached to the `/app/views/book/_form.erb` View, as `Book` references its parent `Author` through the `author_id` which is attached when selected from the dropdown in the Book-Form-View. 

Remember during the creation of `Book` we used the: `author:references` which adds an index of `author_id` inside the `Book`'s DB Schema whereby a `Book` only exists as a reference to an `Author` and requires an `author_id` to be set upon its creation. In that sense a `Book` **belongs_to** an `Author`, but not the other way around(Author belonging to a Book). 

It is like the `Book` has to report its status to its parent `Author` through the linked parent ID in this case `author_id`. 

Overall this means an `author_id` **must exist before** a book can be saved as a book is only an extension of an author in that sense. 

We **still can** attach a `Book` in the Author-Form-View(app/views/author_form.html.erb); and as indicated [here](https://medium.com/@onyoo/why-accepts-nested-attributes-for-6ed190def58a), there is a cleaner solution which involves the using of a in-built helper `accepts_nested_attributes_for` on the Model, which will save us from a lot of extra coding in other places. This is just noted here for a post in the future about this topic.


Things Encountered Along the way
----

#### Migrations  
Initially when creating this I didnt create a Title property for the Book model, but no problem it's easy to generate a migration
```
 rails g migration add_column_title_to_book title:string
 rails db:migrate
```
This automagically creates a migration for adding a title column in the Book schema.

#### After Migration 
Update the view:

```
# Update the view to match section 2.4 above
```
##### Update allowed Params
Update the Controller
> app/controllers/books_controller.rb

```ruby
  # From
  def book_params
    params.require(:book).permit(:author_id)
  end
```
```ruby
   #To 
  def book_params
    params.require(:book).permit(:author_id, :title)
  end
```
This allows the params to be passed through correctly

In the Console
-----
commands are as follows
once data has already been entered:

```
# Get the first author and display their related books
a = Author.first
a.books
```
The above shows the related books based on a seclected author.

```
# Get the first Book and see its corresponding Author
b = Book.first
b.author
```
Above we see the reverse, where we have selected a book and see the corresponding author


Additional Stuff
-----

#### Clearing DB or Seeding Data for testing
So I had already created the data using the Rails UI; however I wanted to then create a SEED file from the already existing data;
Well thats the gist of doing it anyway however installed the `seed_dump` `gemfile`, did bundle install and ran:

```     
#This exported all my existing data to the seeds.rb file
rake db:seed:dump
     
#So in the demo application to populate all I need to do is run :
rails db:seed
```
```
#If data already exists run : 
rails:db:reset

#This will drop all tables_records, recreate the schema and then load the seeds file
```
##### References
-  [Collection Selection](https://theresamorelli.medium.com/collection-select-what-the-heck-4e1cabc4be4b)
-  [Creating a Seed file from existing data](https://medium.com/railstips/create-seed-file-from-data-already-in-database-in-rails-660e5ab92b5)
-  [Seed Dump ^^](https://github.com/rroblak/seed_dump)   
