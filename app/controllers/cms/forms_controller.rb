class Cms::FormsController < Cms::ContentBlockController

  before_filter :associate_form_fields, only: [:create, :update]

  protected

  # Split the space separated list of ids into an actual array of ids.
  # Rails might have a more conventional way to do this, but I couldn't figure it out.'
  def associate_form_fields
    field_ids = params[:field_ids].split(" ")
    params[:form][:field_ids] = field_ids
  end
end
