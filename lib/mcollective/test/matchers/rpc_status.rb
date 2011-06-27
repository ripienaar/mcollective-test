module MCollective
    module Test
        module Matchers
            def rpc_success; RPCStatus.new(0); end
            def rpc_aborted; RPCStatus.new(1); end
            def rpc_unknown_action; RPCStatus.new(2); end
            def rpc_missing_data; RPCStatus.new(3); end
            def rpc_invalid_data; RPCStatus.new(4); end
            def rpc_unknown; RPCStatus.new(5); end

            alias be_successful rpc_success
            alias be_aborted_error rpc_aborted
            alias be_unknown_action_error rpc_unknown_action
            alias be_missing_data_error rpc_missing_data
            alias be_invalid_data_error rpc_invalid_data
            alias be_unknown_error rpc_unknown

            class RPCStatus
                def initialize(code)
                    @code = code
                end

                def matches?(actual)
                    if actual == []
                        return false
                    end
                    [actual].flatten.each do |result|
                        result = result.results if result.is_a?(MCollective::RPC::Result)

                        @actual = result[:statuscode]

                        unless @actual == @code
                            return false
                        end
                    end
                end

                def failure_message
                    "expected :statuscode == #{@code} but got '#{@actual}'"
                end

                def negative_failure_message
                    "expected :statucode != #{@code} but got '#{@actual}'"
                end
            end
        end
    end
end
