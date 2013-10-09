# Make a Form Builder

* Disable input on the fields in preview.
* REFACTOR: Remove :sample_field and new_field from the form.
* BUG: After adding a field, need to reset the drop down to remove the selections.
* Forms should allow either display a message to the user, or redirect them to another page.
* Forms should be addressable.
* Can have duplicate field names that creates issues when submitting forms.

## Eventual Goals

* Delete fields
* Handle errors with validation
* Formating validation (i.e. email, phone)
* Captcha?
* Allow sorting/reporting.
* (IA) Need to figure out where the 'Entries' for a form should appear. (The current 'entries' link won't work when forms live on their own)

## Issues

* When editing the field, if you hit enter it creates the field, but renders the JSON result

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