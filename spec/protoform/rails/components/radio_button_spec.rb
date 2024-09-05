# frozen_string_literal: true

RSpec.describe Protoform::Rails::Components::RadioButton, type: :view do
  let(:model) { double(:model, marital_status: nil) }
  let(:field) { Protoform::Field.new(:marital_status, parent: nil, object: model) }

  it "renders a radio button" do
    render described_class.new(field, value: "Married")

    expect(page).to have_field(
      :marital_status,
      type: :radio,
      checked: false,
      with: "Married",
      id: "marital_status_married",
      name: "marital_status"
    )
  end

  it "allows passing in a symbol value" do
    render described_class.new(field, value: :Married)

    expect(page).to have_field(
      :marital_status,
      type: :radio,
      checked: false,
      with: "Married",
      id: "marital_status_married",
      name: "marital_status"
    )
  end

  it "allows overriding the value" do
    render described_class.new(field, value: "Married")

    expect(page).to have_field(
      :marital_status,
      type: :radio,
      checked: false,
      with: "Married",
      id: "marital_status_married",
      name: "marital_status"
    )
  end

  context "when the model has a value" do
    before do
      allow(model).to receive(:marital_status).and_return("Married")
    end

    it "renders a checked radio button" do
      render described_class.new(field, value: "Married")

      expect(page).to have_field(
        :marital_status,
        type: :radio,
        checked: true,
        with: "Married",
        id: "marital_status_married",
        name: "marital_status"
      )
    end
  end
end
