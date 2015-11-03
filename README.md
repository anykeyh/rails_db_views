# rails_db_views

Provide tools to create and manage database view through your Rails projects.

# Why I've made this gem?

Database views can be really useful providing kind of read only models.
They can help you make your SQL code more reusable, clear, and sometimes are priceless to reduce complexity into models relations.

However, there's no useful tools offered by Ruby On Rails to deal with database views.
Using the classic migration system can be fastidious if you want to update one of your view.
Also, rollback/migrate a view is a non-sense, since there's no data integrity to deal with.

Finally, whenever you migrate and remove a field from a table used by a view, postgresql will throw an error, so removing views before applying migration is not an option.

# Changelog

## 0.4 - Finally `rails_db_view` comes with new features!

## Functions

You can now create functions, just putting your `.sql` files into
the `db/functions` directory.
The functions will be created and/or replaced before all pending migration.

## Deletion

Moreover, you can force the deletion of a view or function using the new directive `remove`.
Getting bored about this *top_30_articles_in_belgium* view and want a *top_50_articles_in_belgium* instead?
Just set `--!deleted` into the file which defined the old view, and that's it!
The view will be removed and not created again!

## Refactoring

I've made a refactoring into the gem, to make it more understandable and easy to fork. Also two views with the same name in differents paths will trigger an `AmbigousNameError`.

Errors and error messages are more clear (one type per kind of error).


## 0.3 - fix rails version to be able to use with rails >4.


# How to use

Quite simple. Add rails_db_view in your Gemfile:

```Gemfile
gem 'rails_db_views'
```

Then create your views into `db/views` directory (create the directory if needed).
All your views are files with "sql" extensions, without the directive `CREATE VIEW xxx AS`.
Just the SQL (like classic SQL request then!)
rails_db_views will use the filename without extension as view name (so avoid special characters like "." or "-" into filename...).

Whenever you'll do `rake db:migrate` or `rake db:rollback`, prior to applying the migrations, rails_db_views will remove all referenced views. After all migrations are done, rails_db_views will reconstruct each views.

# Advanced options

## Requirement of subviews and subfunctions.

In some case we need to build view using another view as target:

```SQL
CREATE VIEW view_a AS SELECT 1 as id;
CREATE VIEW view_b AS SELECT id FROM view_a;
```

In this case, the view creation/drop order is important. I've made a directive system to manage view order:

In `db/views/view_a.sql`:

```SQL
SELECT 1 as id;
```

In `db/views/view_b.sql`:

```SQL
--!require view_a
SELECT id FROM view_a
```

That's it! You can also use `#!require ... ` instead of `--`. But avoid space between the commentaries characters and the directive (!require).

For the functions, they will be installed before the views, so you can use them in your views.

## Configurate paths & extensions

You can add/remove new paths in the initializers of Rails:

```ruby
Rails.configure do |config|
  config.rails_db_views[:views_path] += %w( /some/view/path )
  config.rails_db_views[:views_ext] = "*.dbview" #Using custom extensions to override default ".sql" extension.
end
```

# Licensing

A project [Kosmogo](http://www.kosmogo.com).
Based on an idea of Jimmy Wang of [Ekohe](http://www.ekohe.com)

MIT. Use it, fork it, have fun!

Happy coding!

Yacine.