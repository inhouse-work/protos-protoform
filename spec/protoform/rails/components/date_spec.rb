# frozen_string_literal: true

RSpec.describe Protoform::Rails::Components::Date, type: :view do
  it "renders a datetime-local field" do
    object = double(:object, date: Date.new(2024, 1, 1))
    field = Protoform::Field.new(:date, parent: nil, object:)

    render described_class.new(
      field,
      min: Date.new(2024, 1, 1),
      max: Date.new(2024, 1, 2)
    )

    expect(page).to have_field(
      :date,
      type: "date",
      with: "2024-01-01",
      id: "date",
      name: "date"
    )

    expect(page).to have_css("input[min='2024-01-01']")
    expect(page).to have_css("input[max='2024-01-02']")
  end
end
