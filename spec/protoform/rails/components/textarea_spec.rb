# frozen_string_literal: true

RSpec.describe Protoform::Rails::Components::Textarea, type: :view do
  it "renders a textarea" do
    object = double(:object, foo: "Some text")
    field = Protoform::Field.new(:foo, parent: nil, object:)

    render described_class.new(field)

    expect(page).to have_field(
      :foo,
      type: :textarea,
      with: "Some text",
      id: "foo",
      name: "foo"
    )
  end
end
