RSpec.describe Protoform::Rails::Components::Input, type: :view do
  {
    text: "Some text",
    number: 123,
    date: Date.new(2020, 1, 1),
    url: URI.parse("http://example.com"),
    time: Time.new(2020, 1, 1, 12, 0)
  }.each do |type, value|
    it "renders an input with type #{type}" do
      object = double(foo: value)
      field = Protoform::Field.new(:foo, parent: nil, object:)
      render described_class.new(field)

      expect(page).to have_field(type:)
    end
  end

  it "does not add a value for files or images" do
    object = double(foo: "file")
    field = Protoform::Field.new(:foo, parent: nil, object:)
    render described_class.new(field, type: :file)

    expect(page).to have_field(type: :file)
    expect(page).to have_no_css("input[value='file']")
  end
end
