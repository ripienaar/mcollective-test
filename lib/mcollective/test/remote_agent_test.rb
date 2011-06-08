module MCollective
    module Test
        class RemoteAgentTest
            attr_reader :agent, :plugin

            include MCollective::RPC

            def initialize(agent)
                @agent = agent.to_s
                @plugin = rpcclient(agent)
                @plugin.progress = false
            end
        end
    end
end
