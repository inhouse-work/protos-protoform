# frozen_string_literal: true

RSpec.describe Protoform::Rails::Components::Label, type: :view do
  let(:model) { double(:model, foo: true) }
  let(:field) { Protoform::Field.new(:foo, parent: nil, object: model) }

  it "renders a label for an input" do
    render described_class.new(field)

    expect(page).to have_css("label[for='foo']", text: "Foo")
  end

  it "renders a label with a value suffix" do
    render described_class.new(field, value: "Bar Baz")

    expect(page).to have_css("label[for='foo_bar_baz']", text: "Foo")
  end

  it "renders a label with symbol value" do
    render described_class.new(field, value: :bar_baz)

    expect(page).to have_css("label[for='foo_bar_baz']", text: "Foo")
  end
end
