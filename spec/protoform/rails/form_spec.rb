# frozen_string_literal: true

require "active_model"

RSpec.describe Protoform::Rails::Form, type: :view do
  let(:model) { TestModel.new(addresses: [Address.new(street: "123 Main St")]) }
  let(:helpers) { double("Helpers", form_authenticity_token: "token", url_for: "/") }

  before do
    stub_const(
      "TestModel", Class.new do
        include ActiveModel::API
        include ActiveModel::Attributes

        def self.name
          "Something"
        end

        def persisted?
          false
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

    stub_const(
      "TestForm", Class.new(Protoform::Rails::Form) do
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
    )
  end

  context "with a GET method" do
    before do
      form = TestForm.new(
        model,
        helpers:,
        action: "/posts",
        method: :get
      )

      render form
    end

    it "renders the expected action and method" do
      expect(page).to have_css("form[method='get'][action='/posts']")
    end

    it "doesn't render a method field" do
      expect(page).to have_no_field(type: "hidden", name: "_method")
    end

    it "renders the form without an authenticity token" do
      expect(page).to have_no_field(type: "hidden", name: "authenticity_token")
    end
  end

  context "without an authenticity token" do
    before do
      form = TestForm.new(
        model,
        helpers:,
        authenticity_token: false,
        action: "/posts",
        method: :patch
      )

      render form
    end

    it "renders the expected action and method" do
      expect(page).to have_css("form[method='post'][action='/posts']")
    end

    it "renders the expected method field" do
      expect(page).to have_field(type: "hidden", name: "_method", with: "patch")
    end

    it "renders the form without an authenticity token" do
      expect(page).to have_no_field(type: "hidden", name: "authenticity_token")
    end
  end

  context "with defaults" do
    before do
      form = TestForm.new(model, helpers:, method: :patch)

      # method: :patch should override the persisted? false from the model
      expect(helpers).to receive(:url_for).with(action: :update)

      form.assign(
        name: "Test",
        email: "",
        contact: { phone: "" },
        addresses: [{ street: "" }]
      )

      render form
    end

    it "renders the form" do
      expect(page).to have_css("form[action='/']")
    end

    it "renders the rails based form fields" do
      expect(page).to have_field(type: "hidden", name: "authenticity_token", with: "token")
      expect(page).to have_field(type: "hidden", name: "_method", with: "patch")
    end

    it "renders the form fields" do
      expect(page).to have_field(type: "text", name: "something[name]")
      expect(page).to have_field(type: "email", name: "something[email]")
      expect(page).to have_field(type: "tel", name: "something[contact][phone]")
      expect(page).to have_field(type: "text", name: "something[addresses][0][street]")
    end
  end
end
