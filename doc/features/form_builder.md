# Make a Form Builder

* Then pick another input type (Dropdown?)  [Add subclasses?]
* Need to allow be able to select template for specific forms.
* Can have duplicate field names that creates issues when submitting forms.
* Getting duplicate form fields when creating forms on occasion. (Enter twice?)
* Need sample forms css for the front end viewing of pages (bootstrap styles)
* Forms do not appear in menus
* Form entries cannot be submitted by public users.

## Eventual Goals

* Delete fields
* Handle errors with validation
* Formating validation (i.e. email, phone)
* Captcha?
* Allow sorting/reporting.
* [MINOR] Unique icon for forms (i.e. custom) for sitemap
* Submitting form within frame creates nested frames (for errors?)

## Issues to file

* BUG: After adding a field, it clears but does not correctly show the 'blank' value.


## Introducing Underscore

Does the following work?

_(FormBuilder.prototype).extend({
    method: function(){
      // Do whatever
    }
});

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