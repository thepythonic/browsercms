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
  var cloned_field = $('.form_sample_field').clone();
  $('#new-form-fields').before(cloned_field);
  var input = cloned_field.find("[data-field-type='" + field_type + "']");
  cloned_field.removeClass('form_sample_field');
  var randomId = formBuilder.randomId();
  cloned_field.attr('id', randomId);
  cloned_field.find('input').after('<a class="btn edit_form_button" data-field-ref="' + randomId + '">Edit Field</a>');
  $('.edit_form_button').on('click', function() {
    formBuilder.field_being_editted = $(this).data('field-ref');
    $('#modal-edit-field').modal('show');
  });
};

FormBuilder.prototype.createField = function() {
  var form = $('#new_form_field');
  var data = form.serialize();
  var url = form.attr('action');

  $.post(url, data,
    function(field) {
      $('#field_ids').val( $('#field_ids').val() + " " + field.id);
      $('#' +  formBuilder.field_being_editted).find('label').html(field.label);
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

  // Start with a single field.
  formBuilder.newField('text_field');
});
