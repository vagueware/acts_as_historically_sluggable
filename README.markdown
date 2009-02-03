# ActsAsHistoricallySluggable

So, let's say you have a Blog Post. And you want to have the URL for that blog post be pretty (human-readable). 

You *could* include the id in the blog post, but you think that's ugly or you don't like exposing internal ids. 

You *could* use a slug based on the title, but what if the title changes? Do you update the slug (and let folks 404 when they link to your blog post using the old slug) or leave it alone (and have it be a mis-match for the title and page content)?

What if you didn't have to think about it? What if your slug was automatically generated from your blog post title every time you set or change the title, but old slugs would magically redirect with an HTTP 301.

Hey! Guess what? That's what this plugin does.

# Example

## Model

    class BlogPost < ActiveRecord::Base
      acts_as_historically_sluggable :title
    end

Assuming a BlogPost with a title of "I Want Candy", you will have:

	>> post.slug
	=> "i_want_candy"
	>> post.current_slug
	=> #<Slug id: 140, identifier: "i_want_candy", sluggable_type: "BlogPost", sluggable_id: 93, created_at: "2009-02-03 15:44:31", updated_at: "2009-02-03 15:44:31">
	>> page.slugs
	=> [#<Slug id: 140, identifier: "i_want_candy", sluggable_type: "Page", sluggable_id: 93, created_at: "2009-02-03 15:44:31", updated_at: "2009-02-03 15:44:31">]
	
Slugs will automatically be created for you when your model is saved and the attribute from which to generate the slug (in this case, the 'title' attribute) has changed. 

There is also enforcement of the fact that Slugs must be unique within the set of active (read: not out-of-date) Slugs for the particular model class.
	
## Controller

    class BlogPostsController < ActionController::Base
      find_object_by_slug :blog_post, :only => [:show]
    end

This will automatically try to find a BlogPost with the given slug. If it can't be found, an ActiveRecord::RecordNotFound is thrown (you can use a rescue_from macro to handle this). If it's found, but out of date, an HTTP 301 (permanent redirect) will be sent to the client. If it's found and active (i.e. not out of date), `@blog_post` will be set. 

## Migration

You can rock a migration to add a slugs table with:

	./script/generate slug_migration

# Tests

Dig the tests (shoulda required):

    rake test:plugins PLUGIN=acts_as_historically_sluggable

-----

Copyright (c) 2009 [Scrum Alliance](www.scrumalliance.org), released under the MIT license. 

Authored by: 

* [Dan Hodos](mailto:danhodos[at]gmail[dot]com)
* [Doug Alcorn](mailto:dougalcorn[at]gmail[dot]com)