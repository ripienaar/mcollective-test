module MCollective
    module Test
        module Matchers
            def have_data_items(*items); RPCResultItems.new(items); end

            class RPCResultItems
                def initialize(expected)
                    @expected = expected.flatten.sort
                end

                def matches?(actual)
                    [actual].flatten.each do |result|
                        result = result.results if result.is_a?(MCollective::RPC::Result)

                        @actual = result[:data].keys.sort

                        unless @actual == @expected
                            return false
                        end
                    end

                    true
                end

                def failure_message
                    "expected keys '#{@expected.join ', '}' but got '#{@actual.join ', '}'"
                end

                def negative_failure_message
                    "did not expect keys '#{@expected.join ', '}' but got '#{@actual.keys.join ', '}'"
                end
            end
        end
    end
end
