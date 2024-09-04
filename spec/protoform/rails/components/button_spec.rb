# frozen_string_literal: true

RSpec.describe Protoform::Rails::Components::Button, type: :view do
  it "renders a button" do
    object = double(:object, foo: "Some text")
    field = Protoform::Field.new(:foo, parent: nil, object:)

    render described_class.new(field, value: "something")

    expect(page).to have_button(
      text: "Something",
      value: "something",
      id: "foo",
      name: "foo"
    )
  end
end
