RSpec::Matchers.define(:have_a_description) do |expected|
  match do |actual|
    actual = actual.application_description

    if expected
      actual == expected
    else
      !actual.nil?
    end
  end

  failure_message do |actual|
    actual = actual.application_description

    if expected
      "application should have description #{expected.inspect} but got #{actual.inspect}"
    else
      "application should have a description, got #{actual.inspect}"
    end
  end

  failure_message_when_negated do |actual|
    actual = actual.application_description

    if expected
      "application should not have a description matching #{expected.inspect} but got #{actual.inspect}"
    else
      "application should not have a description, got #{actual.inspect}"
    end
  end
end
