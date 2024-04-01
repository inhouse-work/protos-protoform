class Form < Protoform::Rails::Form
  def template
    render field(:name).input
  end
end

RSpec.describe Protoform::Rails::Form, type: :view do
  it "renders the form" do
    model_name = double("ModelName", param_key: "something")
    model = double("Model", model_name:, persisted?: true)
    helpers = double("Helpers", form_authenticity_token: "token", url_for: "/")
    render Form.new(model, helpers:)

    expect(page).to have_css("form")
    expect(page).to have_field("something[name]")
  end
end
