# Make a Form Builder

* Forms should allow either display a message to the user, or redirect them to another page.
* Forms should be addressable.
* Need to figure out where the 'Entries' for a form should appear. (The current 'entries' link won't work when forms live on their own)
* Can have duplicate field names that creates issues when submitting forms.

## Eventual Goals

* Handle errors with validation
* Formating validation (i.e. email, phone)
* Captcha?
* Allow sorting/reporting.

## Issues

* When editing the field, if you hit enter it creates the field, but renders the JSON result
* Creating multiple fields: I needs to blank the field form each time.

## Reference Articles

### ActiveRecord::Store

* http://blog.chrisblunt.com/rails-3-storing-model-metadata-attributes-with-activerecordstore/
* http://rcode5.wordpress.com/2012/11/23/flexible-rails-modeling-with-activerecordstore-part-ii/

### Other

* (hstore vs key/value table) http://blog.artlogic.com/2012/09/13/custom-fields-in-rails/
* (Practical Overview for Key Store databases - no relevant here) http://www.slideshare.net/marc.seeger/keyvalue-stores-a-practical-overview

## Gems

* Moneta - Key Value API with ActiveRecord backend (https://github.com/minad/moneta)
* http://rubygems.org/gems/ledermann-rails-settings (JSON storage)
* http://blog.artlogic.com/2012/09/13/custom-fields-in-rails/ (