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

## 0.0.6 – Support of rails 5 and \#{ String replacement }

We are proud to announce than `rails-db-views` works well into Rails 5 project.
We are using it in already two differents projects, and everything works.

Due to another project, we needed to add the string replacement functionnality.
Because we are using `dblink` extension, and we don't want to share the parameters
like password or dbname straight into the view file.

```sql
  dblink('dbname=database user=user password=password', 'SELECT * FROM SOME_SQL')
```

Then become:

```sql
  dblink('dbname=#{ENV['DB_NAME']} user=#{ENV['DB_USER']} password=#{ENV['DB_PASSWD']}', 'SELECT * FROM SOME_SQL')
```

## 0.0.5 – Bugfixes and test

I fixed issues making the gem not working + added a more complex example/test. You can call "rake test" into the dummy to check (even if it's not automated unit test...).
The example use heavily postgres functionnality, so it works only on postgres.

## 0.0.4 - Finally `rails_db_view` comes with new features!

### Functions

You can now create functions, just putting your `.sql` files into
the `db/functions` directory.
The functions will be created and/or replaced before all pending migration.

### Deletion

Moreover, you can force the deletion of a view using the new directive `remove`.
Getting bored about this *top_30_articles_in_belgium* view and want a *top_50_articles_in_belgium* instead?
Just set `--!deleted` into the file which defined the old view, and that's it!
The view will be removed and not created again!

Be aware this is not working with function yet.

### Configuration

The configuration change a little bit. If you update, please check the instructions below.

### Refactoring

I've made a refactoring into the gem, to make it more understandable and easy to fork. Also two views with the same name in differents paths will trigger an `AmbigousNameError`.

Errors and error messages are more clear (one type per kind of error).

## 0.0.3

First working commit
I've fixed rails version to be able to use with rails >4.

# How to use

Quite simple. Add rails_db_view in your Gemfile:

```Gemfile
gem 'rails_db_views', github: 'anykeyh/rails_db_views'
```

*Note: Don't use the rubygem one, it's probably outdated...*

## Views
You create your views into `db/views` directory (create the directory if needed).
All your views are files with "sql" extensions, without the directive `CREATE VIEW xxx AS`.
Just the SQL (like classic SQL request then!)
rails_db_views will use the filename without extension as view name (so avoid special characters like "." or "-" into filename...).

Whenever you'll do `rake db:migrate` or `rake db:rollback`, prior to applying the migrations, rails_db_views will remove all referenced views. After all migrations are done, rails_db_views will reconstruct each views.

## Functions

You create your function without the directive `CREATE FUNCTION xxx`

Here's a simple example of the function `add`:
```SQL
(x integer, y integer) RETURNS integer AS $$
  BEGIN
    RETURN x + y;
  END;
$$ LANGUAGE plpgsql;
```

_*IMPORTANT NOTICE FOR POSTGRES USERS:*_

If you're using function to build indexes in postgresql, please consider to reconstruct the index once you've changed your function:
```SQL
reindex index $index_name
```
postgres is smart enough to don't replace the function if it's exactly the same function than before, so no need to rebuild your indexes at every migrations! :)
See more informations [here](http://stackoverflow.com/questions/17601719/replace-function-used-in-index)

# Database compatibility

I've tested the gem only on postgres and sqlite. Use it on mysql or else at your *own risks*.

Obviously, beware function definition doesn't work on sqlite, because the engine doesn't allow it. Hey, it's *lite* ok? :-)

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

~~That's it! You can also use `#!require ... ` instead of `--`. But avoid space between the commentaries characters and the directive (!require).~~ **Now you can put any space you want!**

For the functions, they will be installed before the views, so you can use them in your views without problems!

## Configurate paths & extensions

You can add/remove new paths in the initializers of Rails:

```ruby
Rails.configure do |config|
  config.rails_db_views.views_path += %w( /some/view/path )
  config.rails_db_views.views_extension = "*.sql"

  config.rails_db_views.functions_path += %w( /some/function/path )
  config.rails_db_views.functions_extension = "*.sql"

  config.rails_db_views.migration_tasks += %w( db:migrate:with_data )
end
```

# Licensing

A project [Kosmogo](http://www.kosmogo.com).
Based on an idea of Jimmy Wang of [Ekohe](http://www.ekohe.com)

MIT. Use it, fork it, have fun!

Happy coding!

Yacine.
