RSpec::Matchers.define(:have_data_items) do |expected|
  match do |actual|
    actual.should include(data: include(expected))
  end
end
