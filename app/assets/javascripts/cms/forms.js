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

// Add a new field to the form
// (Implementation: Clone existing hidden form elements rather than build new ones via HTML).
FormBuilder.prototype.newField = function(field_type) {
  this.hideNewFormInstruction();
  this.cloneSampleField(field_type);
  this.enableEditButtons();
  this.resetAddFieldButton();
};

FormBuilder.prototype.resetAddFieldButton = function() {
  $("#form_new_entry_new_field").val('1');
};

FormBuilder.prototype.cloneSampleField = function(field_type) {
  var sample_field_class = 'form_new_entry_sample_field';
  var cloned_field = $('.' + sample_field_class).clone();
  $('#new-form-fields').before(cloned_field);
  var input = cloned_field.find("[data-field-type='" + field_type + "']");
  cloned_field.removeClass(sample_field_class);
};

// Function that triggers when users click the 'Edit' field button.
FormBuilder.prototype.editFormField = function() {
  // This is the overall container for the entire field.
  formBuilder.field_being_editted = $(this).parents('.control-group');
  $('#modal-edit-field').removeData('modal').modal({
    show: true,
    remote: $(this).attr('data-edit-path')
  });

  // Handle Enter by submitting the form via AJAX.
  $('#modal-edit-field').on('shown', function() {
    formBuilder.new_field_form().on("keypress", function(e) {
      if (e.which == 13) {
        formBuilder.createField();
        e.preventDefault();
        $('#modal-edit-field').modal('hide');
        return false;
      }
    });
  });

};


FormBuilder.prototype.hideNewFormInstruction = function() {
  var no_fields = $("#no-field-instructions");
  if (no_fields.exists()) {
    no_fields.hide();
  }
};

// Add handler to any edit field buttons.
FormBuilder.prototype.enableEditButtons = function() {
  $('.edit_form_button').on('click', formBuilder.editFormField);
};

FormBuilder.prototype.new_field_form = function() {
  return $('#ajax_form_field');
};
FormBuilder.prototype.createField = function() {
  var form = formBuilder.new_field_form();
  var data = form.serialize();
  var url = form.attr('action');

  $.post(url, data,
    function(field) {
      $('#field_ids').val($('#field_ids').val() + " " + field.id);
      formBuilder.field_being_editted.find('label').html(field.label);
      formBuilder.field_being_editted.find('a').attr('data-edit-path', field.edit_path);
    }).fail(function() {
      alert("An error occurred.");
    });

};

//FormBuilder.prototype.handleEnter = function(event) {
//  if (event.which == 13) {
//    alert('You pressed enter!');
//  }
//};
// Attaches behavior to the proper element.
FormBuilder.prototype.setup = function() {
  var select_box = $('.add-new-field');
  if (select_box.exists()) {
    select_box.change(function() {
      formBuilder.newField($(this).val());
    });

    this.enableEditButtons();
    $("#create_field").on('click', formBuilder.createField);
//    this.new_field_form().keypress(formBuilder.handleEnter);
  }
};
var formBuilder = new FormBuilder();

// Register FormBuilder handlers on page load.
$(function() {
  formBuilder.setup();


  // Include a text field to start (For easier testing)
  // formBuilder.newField('text_field');
});
