# frozen_string_literal: true

RSpec.describe Protoform::Rails::Components::RadioButton, type: :view do
  it "renders a radio button" do
    object = double(:object, marital_status: "Married")
    field = Protoform::Field.new(:marital_status, parent: nil, object:)

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
