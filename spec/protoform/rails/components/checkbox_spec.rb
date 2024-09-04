# frozen_string_literal: true

RSpec.describe Protoform::Rails::Components::Checkbox, type: :view do
  it "renders a checkbox input" do
    object = double(:object, foo: true)
    field = Protoform::Field.new(:foo, parent: nil, object:)

    render described_class.new(field)

    expect(page).to have_field(:foo, type: :checkbox, checked: true, with: "1", id: "foo", name: "foo")
    expect(page).to have_field(:foo, type: :hidden, with: "0", name: "foo")
  end
end
