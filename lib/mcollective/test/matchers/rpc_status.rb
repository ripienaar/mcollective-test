{
  0 => :rpc_success,
  1 => :rpc_aborted,
  2 => :rpc_unknown_action,
  3 => :rpc_missing_data,
  4 => :rpc_invalid_data,
  5 => :rpc_unknown
}.each do |code, name|
  RSpec::Matchers.define(name) do
    match do |actual|
      actual[:statuscode] == code
    end

    failure_message do |actual|
      "expected :statuscode == #{code} but got #{actual[:statuscode]}"
    end

    failure_message_when_negated do |actual|
      "expected :statuscode != #{code} but got #{actual[:statuscode]}"
    end
  end
end

RSpec::Matchers.alias_matcher :be_successful, :rpc_success
RSpec::Matchers.alias_matcher :be_aborted_error, :rpc_aborted
RSpec::Matchers.alias_matcher :be_unknown_error, :rpc_unknown_action
RSpec::Matchers.alias_matcher :be_missing_data_error, :rpc_missing_data
RSpec::Matchers.alias_matcher :be_invalid_data_error, :rpc_invalid_data
RSpec::Matchers.alias_matcher :be_unknown_error, :rpc_unknown
