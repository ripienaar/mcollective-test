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
                        @nodeid = result[:data][:test_sender]
                        @actual << result
                        @expected.each do |e|
                            if e.is_a? Hash
                                if (e.keys.map{|k| result[:data].keys.include?(k)}.include?(false))
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
                    return_string = "Failure from #{@nodeid}\n"
                    return_string << "Expected : \n"
                    @expected.each do |e|
                        if e.is_a? Hash
                            e.keys.each do |k|
                                return_string << " '#{k}' with value '#{e[k]}'\n"
                            end
                        else
                            return_string << " '#{e}' to be present\n"
                        end
                    end

                    return_string << "Got : \n"
                    @actual.each do |a|
                        if a[:sender] == @nodeid
                            a[:data].each do |data|
                                return_string << " '#{data[0]}' with value '#{data[1]}'\n"
                            end
                        end
                    end

                    return_string
                end

                def negative_failure_message
                    return_string = "Failure from #{@nodeid}\n"
                    return_string << "Did not expect : \n"
                    @expected.each do |e|
                        if e.is_a? Hash
                            e.keys.each do |k|
                                return_string << " '#{k}' with value '#{e[k]}'\n"
                            end
                        else
                            return_string << " '#{e}' to not be present\n"
                        end
                    end

                    return_string << "But got : \n"
                    @actual.each do |a|
                        if a[:sender] == @nodeid
                            a[:data].each do |data|
                                return_string << " '#{data[0]}' with value '#{data[1]}'\n"
                            end
                        end
                    end

                    return_string
                end

            end
        end
    end
end
