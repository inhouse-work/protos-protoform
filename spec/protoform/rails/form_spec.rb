# frozen_string_literal: true

class TestForm < Protoform::Rails::Form
  def template
    render field(:name).input(type: :text)
    render field(:email).input(type: :email)

    namespace(:contact) do |contact|
      render contact.field(:phone).input(type: :tel)
    end
  end
end

RSpec.describe Protoform::Rails::Form, type: :view do
  before do
    model_name = double("ModelName", param_key: "something")
    model = double(
      "Model",
      model_name:,
      persisted?: true,
      addresses: [
        double("Address", street: "123 Fake St")
      ]
    )

    render TestForm.new(
      model,
      helpers: double("Helpers", form_authenticity_token: "token", url_for: "/")
    )
  end

  it "renders the form" do
    expect(page).to have_css("form")
  end

  it "renders the rails based form fields" do
    expect(page).to have_field(type: "hidden", name: "authenticity_token", with: "token")
    expect(page).to have_field(type: "hidden", name: "_method", with: "patch")
  end

  it "renders the form fields" do
    expect(page).to have_field(type: "text", name: "something[name]")
    expect(page).to have_field(type: "email", name: "something[email]")
    expect(page).to have_field(type: "tel", name: "something[contact][phone]")
  end
end
