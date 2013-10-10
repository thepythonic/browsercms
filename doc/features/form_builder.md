# Make a Form Builder

* Forms should allow either display a message to the user, or redirect them to another page.
* Make Text Area work.
* Slug isn't being displayed as editable for forms.
* Need to allow be able to select template for specific forms.
* Can have duplicate field names that creates issues when submitting forms.
* Not sure what the effect of being able to change the names of form fields will have.

## Eventual Goals

* Delete fields
* Handle errors with validation
* Formating validation (i.e. email, phone)
* Captcha?
* Allow sorting/reporting.

## Issues to file

* BUG: After adding a field, it clears but does not correctly show the 'blank' value.

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