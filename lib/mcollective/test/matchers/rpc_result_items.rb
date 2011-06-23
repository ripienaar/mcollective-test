module MCollective
    module Test
        module Matchers
            def have_data_items(*items); RPCResultItems.new(items);end

            class RPCResultItems
                def initialize(expected)
                    @expected = expected
                    @actual = []
                end

                def matches?(actual)
                    [actual].flatten.each do |result|
                        result = result.results if result.is_a?(MCollective::RPC::Result)
                        @actual << result
                        @expected.each do |e|
                            if e.is_a? Hash
                                unless result[:data].keys.include?(e.keys)
                                    return false
                                end
                                e.keys.each do |k|
                                    if e[k].is_a?(String) || e[k].is_a?(Regexp)
                                        unless result[:data][k].match e[k]
                                            return false
                                        end
                                    else
                                        unless result[:data][k] == e[k]
                                            return false
                                        end
                                    end
                                end
                            else
                                unless result[:data].keys.include? e
                                    return false
                                end
                            end
                        end
                    end
                    true
                end

                def failure_message
                    "expected keys '#{@expected.join ','}' but got '#{@actual.join ','}'"
                end

                def negative_failure_message
                    "did not expect keys '#{@expected.join ','}' but got '#{@actual.join ','}'"
                end

            end
        end
    end
end
