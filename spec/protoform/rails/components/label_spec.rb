# frozen_string_literal: true

RSpec.describe Protoform::Rails::Components::Label, type: :view do
  it "renders a label for an input" do
    object = double(:object, foo: true)
    field = Protoform::Field.new(:foo, parent: nil, object:)

    render described_class.new(field)

    expect(page).to have_css("label[for='foo']", text: "Foo")
  end

  it "renders a label with a value suffix" do
    object = double(:object, foo: true)
    field = Protoform::Field.new(:foo, parent: nil, object:)

    render described_class.new(field, value: "Bar Baz")

    expect(page).to have_css("label[for='foo_bar_baz']", text: "Foo")
  end
end
