# frozen_string_literal: true

require "active_model"

ApplicationComponent = Class.new(Protos::Component)

class TestForm < Protoform::Rails::Form
  def view_template
    render field(:name).input(type: :text)
    render field(:email).input(type: :email)

    namespace(:contact) do |contact|
      render contact.field(:phone).input(type: :tel)
    end

    collection(:addresses).each do |address|
      render address.field(:street).input(type: :text)
    end
  end
end

RSpec.describe Protoform::Rails::Form, type: :view do
  before do
    stub_const(
      "TestModel", Class.new do
        include ActiveModel::API
        include ActiveModel::Attributes

        def self.name
          "Something"
        end

        def persisted?
          true
        end

        attribute :name
        attribute :email
        attribute :contact
        attribute :addresses
      end
    )

    stub_const(
      "Address", Class.new do
        include ActiveModel::API
        include ActiveModel::Attributes

        def self.name
          "Address"
        end

        attribute :street
      end
    )

    model = TestModel.new(
      addresses: [
        Address.new(street: "123 Main St")
      ]
    )

    form = TestForm.new(
      model,
      helpers: double("Helpers", form_authenticity_token: "token", url_for: "/"),
      method: :post
    )

    form.assign(
      name: "Test",
      email: "",
      contact: { phone: "" },
      addresses: [{ street: "" }]
    )

    render form
  end

  it "renders the form" do
    expect(page).to have_css("form")
  end

  it "renders the rails based form fields" do
    expect(page).to have_field(type: "hidden", name: "authenticity_token", with: "token")
    expect(page).to have_field(type: "hidden", name: "_method", with: "post")
  end

  it "renders the form fields" do
    expect(page).to have_field(type: "text", name: "something[name]")
    expect(page).to have_field(type: "email", name: "something[email]")
    expect(page).to have_field(type: "tel", name: "something[contact][phone]")
    expect(page).to have_field(type: "text", name: "something[addresses][0][street]")
  end
end
