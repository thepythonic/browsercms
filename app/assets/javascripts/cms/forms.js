/**
 * The UI for dynamically creating custom forms via the UI.
 * @constructor
 */

// Determine if an element exists.
//  i.e. if($('.some-class').exists()){ // do something }
jQuery.fn.exists = function() {
  return this.length > 0;
};

var FormBuilder = function() {
};

FormBuilder.prototype.randomId = function() {
  return Math.random().toString(36).substring(7);
};

// Add a new field to the form
// (Implementation: Clone existing hidden form elements rather than build new ones via HTML).
FormBuilder.prototype.newField = function(field_type) {
  this.hideNewFormInstruction();
  var cloned_field = $('.form_sample_field').clone();
  $('#new-form-fields').before(cloned_field);
  var input = cloned_field.find("[data-field-type='" + field_type + "']");
  cloned_field.removeClass('form_sample_field');
  var randomId = formBuilder.randomId();
  cloned_field.attr('id', randomId);
  cloned_field.find('input').attr('data-field-ref', randomId);

  var edit_button = $('#sample_edit_form').clone();
  edit_button.attr('id', '');
  edit_button.attr('data-field-ref', randomId);
  cloned_field.find('input').after(edit_button);
  $('.edit_form_button').on('click', formBuilder.editFormField);
};

// Function that triggers when users click the 'Edit' field button.
FormBuilder.prototype.editFormField = function() {
  formBuilder.field_being_editted = $(this).data('field-ref');
  $('#modal-edit-field').removeData('modal').modal({
    show: true,
    remote: $(this).attr('data-edit-path')
  });
};


FormBuilder.prototype.hideNewFormInstruction = function() {
  var no_fields = $("#no-field-instructions");
  if (no_fields.exists()) {
    no_fields.hide();
  }
};
FormBuilder.prototype.createField = function() {
  var form = $('#ajax_form_field');
  var data = form.serialize();
  var url = form.attr('action');
  console.log("URL to post to is: ", url);

  $.post(url, data,
    function(field) {
      $('#field_ids').val($('#field_ids').val() + " " + field.id);
      var editted_field = $('#' + formBuilder.field_being_editted);
      editted_field.find('label').html(field.label);
//      console.log("Updating to ", field.edit_path, ' on ', editted_field, " which ", editted_field.exists());
      editted_field.find('a').attr('data-edit-path', field.edit_path);
    }).fail(function() {
      alert("An error occurred.");
    });

};

// Attaches behavior to the proper element.
FormBuilder.prototype.setup = function() {
  var select_box = $('.add-new-field');
  if (select_box.exists()) {
    select_box.change(function() {
      formBuilder.newField($(this).val());
    });

    $("#create_field").on('click', formBuilder.createField);
  }
};
var formBuilder = new FormBuilder();

// Register FormBuilder handlers on page load.
$(function() {
  formBuilder.setup();

  formBuilder.newField('text_field');
});
