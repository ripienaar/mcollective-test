RSpec::Matchers.define(:have_data_items) do |expected|
  match do |actual|
    if actual.is_a?(MCollective::RPC::Result)
      actual.results.should include(expected)
    elsif actual.is_a?(MCollective::Data::Result)
      actual.instance_variable_get(:@data).should include(expected)
    else
      actual.should include(data: include(expected))
    end
  end
end
