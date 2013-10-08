# Make a Form Builder

* Formating validation (i.e. email, phone)
* Captcha


## Issues

Right now, all fields for all FormResponses are being set as accessors. (in cms/forms/render.html.erb). This is probably not acceptable, but

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