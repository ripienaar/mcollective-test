module MCollective
  module Test
    module Util
      include Mocha::API

      def create_facts_mock(factsource)
        facts = mock('facts')
        facts.stubs(:get_facts).returns(factsource)

        factsource.each_pair do |k, v|
          facts.stubs(:get_fact).with(k).returns(v)
        end

        PluginManager << {:type => "facts_plugin", :class => facts, :single_instance => false}
      end

      def create_config_mock(config)
        pluginconf = {}

        cfg = mock('config')
        cfg.stubs(:configured).returns(true)
        cfg.stubs(:rpcauthorization).returns(false)
        cfg.stubs(:main_collective).returns("mcollective")
        cfg.stubs(:collectives).returns(["production", "staging"])
        cfg.stubs(:classesfile).returns("classes.txt")
        cfg.stubs(:identity).returns("rspec_tests")
        cfg.stubs(:logger_type).returns("console")
        cfg.stubs(:loglevel).returns("error")
        cfg.stubs(:pluginconf).returns(pluginconf)

        if config
          config.each_pair do |k, v|
            cfg.send(:stubs, k).returns(v)
            if k =~ /^plugin.(.+)/
              pluginconf[$1] = v
            end
          end

          if config.include?(:libdir)
            [config[:libdir]].flatten.each do |dir|
              $: << dir if File.exist?(dir)
            end

            cfg.stubs(:libdir).returns(config[:libdir])
          end
        end


        Config.stubs(:instance).returns(cfg)

        cfg
      end

      def mock_validators
        Validator.stubs(:load_validators)
        Validator.stubs(:validate).returns(true)
      end

      def create_logger_mock
        logger = mock(:logger)

        [:log, :start, :debug, :info, :warn].each do |meth|
          logger.stubs(meth)
        end

        Log.stubs(:config_and_check_level).returns(false)

        Log.configure(logger)

        logger
      end

      def create_connector_mock
        connector = mock(:connector)

        [:connect, :receive, :publish, :subscribe, :unsubscribe, :disconnect].each do |meth|
          connector.stubs(meth)
        end

        PluginManager << {:type => "connector_plugin", :class => connector}

        connector
      end

      def load_application(application, application_file=nil)
        classname = "MCollective::Application::#{application.capitalize}"
        PluginManager.delete("#{application}_application")

        if application_file
          raise "Cannot find application file #{application_file} for application #{application}" unless File.exist?(application_file)
          load application_file
        else
          PluginManager.loadclass(classname)
        end

        PluginManager << {:type => "#{application}_application", :class => classname, :single_instance => false}
        PluginManager["#{application}_application"]
      end

      def load_agent(agent, agent_file=nil)
        classname = "MCollective::Agent::#{agent.capitalize}"

        PluginManager.delete("#{agent}_agent")

        if agent_file
          raise "Cannot find agent file #{agent_file} for agent #{agent}" unless File.exist?(agent_file)
          load agent_file
        else
          PluginManager.loadclass(classname)
        end

        klass = Agent.const_get(agent.capitalize)

        klass.any_instance.stubs("load_ddl").returns(true)
        RPC::Request.any_instance.stubs(:validate!).returns(true)

        PluginManager << {:type => "#{agent}_agent", :class => classname, :single_instance => false}
        PluginManager["#{agent}_agent"]
      end

      def create_response(senderid, data = {}, stats = nil , statuscode = 0, statusmsg = "OK")
        unless stats == nil
          {:senderid => senderid, :body =>{:data => data, :stats => stats}}
        else
          {:senderid => senderid, :body =>{:data => data}}
        end
      end
    end
  end
end
