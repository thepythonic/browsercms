# Make a Form Builder

* BUG: New portlets/products/catalogs don't work (removed block_path)
    * Refactor to remove need for 'block_path' hackery.
    * Issues:
        - Portlets don't get their own routes
    * Add better support for syntax errors during bootup


## Refactor (Look at these classes)
*  EngineHelper -> Remove all path_element helpers
*  ContentBlockController.assign_parent -> Remove
*  ContentType.find_by_key -> Remove Cms:: namespace searching

* BUG: Multiple Attachments (i.e. Catalogs) aren't uploading.
* BUG: Products/Catalogs are not persisting name/slug
* BUG: Adding Portlets is broken
* BUG: Cms::CategoryType.display_name fails (for /cms/category_types/1/edit)
* Features: Generates need to blocks in proper location (/dummy)
* Features: Upgrading project. Need reasonable error messages for missing things.

Changes to document:

    Custom models should have the following added to them:
        Create a directory in the project named app/models/cms
        Move any Content Blocks into that directory.
        Rename from Widget to *Cms::*Widget
        Add self.table_name = :widgets (or migrate the table from widgets to cms_widgets)

* Then pick another input type (Dropdown?)  [Add subclasses?]
* Need to allow be able to select template for specific forms.
* Need a way to clean up new forms that created during 'new' operation. (Leave page JS popup?)

## Eventual Goals

* URL for form submissions could be improved.
* Delete fields
* Fields ordering needs work arbitrary (Address, Name) (might be arbitrary)
* Handle errors with validation
* Formating validation (i.e. email, phone)
* Captcha?
* Allow sorting/reporting.
* [MINOR] Unique icon for forms (i.e. custom) for sitemap
* Submitting form within frame creates nested frames (for errors?)

## Issues to file

* [Developers] Default Forms just uses bootstrap, which is probably not a valid option. Need a way to pare it down to avoid changing styles for existing designes.
* BUG: After adding a field, it clears but does not correctly show the 'blank' value.
* BUG: Addressable content types (product, forms, etc) do not/cannot appear in menus without manually creating a link.

## Documentation

### Configuration

In config/application.rb, to change which CSS stylesheet is applied to Form pages, update the following:

```
 # Default is 'cms/default-forms'
 config.cms.form_builder_css = 'my-forms' # Returns /assets/my-forms.css
```

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