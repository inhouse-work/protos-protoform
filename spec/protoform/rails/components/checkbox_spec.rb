# frozen_string_literal: true

RSpec.describe Protoform::Rails::Components::Checkbox, type: :view do
  let(:field) do
    object = double(:object, foo: true)
    Protoform::Field.new(:foo, parent: nil, object:)
  end

  it "renders a checkbox input" do
    render described_class.new(field)

    expect(page).to have_field(
      :foo,
      type: :checkbox,
      checked: true,
      with: "1",
      id: "foo",
      name: "foo"
    )
    expect(page).to have_field(
      :foo,
      type: :hidden,
      with: "0",
      name: "foo"
    )
  end

  it "renders with options" do
    render described_class.new(
      field,
      include_hidden: false,
      checked_value: "yes",
      checked: false
    )

    expect(page).to have_field(
      :foo,
      type: :checkbox,
      checked: false,
      with: "yes",
      id: "foo",
      name: "foo"
    )
    expect(page).not_to have_field(:foo, type: :hidden)
  end
end
