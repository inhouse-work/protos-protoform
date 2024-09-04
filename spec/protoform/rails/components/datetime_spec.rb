# frozen_string_literal: true

RSpec.describe Protoform::Rails::Components::Datetime, type: :view do
  it "renders a datetime-local field" do
    object = double(:object, datetime: DateTime.new(2024, 1, 1, 12, 0))
    field = Protoform::Field.new(:datetime, parent: nil, object:)

    render described_class.new(
      field,
      min: DateTime.new(2024, 1, 1, 0, 0),
      max: DateTime.new(2024, 1, 1, 23, 59)
    )

    expect(page).to have_field(
      :datetime,
      type: "datetime-local",
      with: "2024-01-01T12:00:00",
      id: "datetime",
      name: "datetime"
    )

    expect(page).to have_css("input[min='2024-01-01T00:00:00']")
    expect(page).to have_css("input[max='2024-01-01T23:59:00']")
  end
end
