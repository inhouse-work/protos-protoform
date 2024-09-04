# frozen_string_literal: true

RSpec.describe Protoform::Rails::Components::Time, type: :view do
  it "renders a time field" do
    object = double(:object, time: Time.new(2024, 1, 1, 12, 0))
    field = Protoform::Field.new(:time, parent: nil, object:)

    render described_class.new(
      field,
      min: Time.new(2024, 1, 1, 0, 0),
      max: Time.new(2024, 1, 1, 23, 59)
    )

    expect(page).to have_field(
      :time,
      type: "time",
      with: "12:00:00.000",
      id: "time",
      name: "time"
    )

    expect(page).to have_css("input[min='00:00:00.000']")
    expect(page).to have_css("input[max='23:59:00.000']")
  end
end
