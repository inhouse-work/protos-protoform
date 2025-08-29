# frozen_string_literal: true

RSpec.describe Protoform::Rails::Components::Submit, type: :view do
  it "renders a button" do
    render described_class.new("Something", disable_with: "Processing...")

    expect(page).to have_css("input[type='submit']")
    expect(page).to have_css("input[value='Something']")
    expect(page).to have_css("input[data-disable-with='Processing...']")
  end
end
