# Make a Form Builder

* Formating validation (i.e. email, phone)
* Captcha
* Entries - Getting them to appear in content library doesn't work.
    1. Class isn't loaded (I think content_block route might be loading block classes on bootup.
    2. Navigation isn't working correctly either.
* Can't edit or view form entries.

## Issues

* When creating a form, the name/description should come before the fields.
* Don't create a field when a form is first created.
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