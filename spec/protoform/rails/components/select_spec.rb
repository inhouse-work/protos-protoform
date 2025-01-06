# frozen_string_literal: true

RSpec.describe Protoform::Rails::Components::Select, type: :view do
  it "renders a single select input" do
    object = double(:object, marital_status: "Married")
    field = Protoform::Field.new(:marital_status, parent: nil, object:)

    render described_class.new(
      field,
      collection: %w[Married Single Divorced],
      include_blank: true,
      multiple: false
    )

    expect(page).to have_select(
      :marital_status,
      selected: "Married",
      options: ["", "Married", "Single", "Divorced"],
      id: "marital_status",
      name: "marital_status"
    )
  end

  context "with a date" do
    it "selects the correct date" do
      object = double(:object, date_of_birth: Date.new(1990, 1, 2))
      field = Protoform::Field.new(:date_of_birth, parent: nil, object:)

      render described_class.new(
        field,
        collection: [
          [Date.new(1990, 1, 1), "1990-01-01"],
          [Date.new(1990, 1, 2), "1990-01-02"]
        ],
        include_blank: true,
        multiple: false
      )

      expect(page).to have_select(
        :date_of_birth,
        selected: "1990-01-02",
        options: ["", "1990-01-01", "1990-01-02"],
        id: "date_of_birth",
        name: "date_of_birth"
      )
    end
  end

  it "renders a multiple select input" do
    object = double(:object, preferences: %w[Food Water])
    field = Protoform::Field.new(:preferences, parent: nil, object:)

    render described_class.new(
      field,
      collection: %w[Food Shelter Water],
      include_blank: false,
      multiple: true
    )

    expect(page).to have_select(
      :preferences,
      selected: %w[Food Water],
      options: %w[Food Shelter Water],
      id: "preferences",
      name: "preferences[]"
    )
  end
end
