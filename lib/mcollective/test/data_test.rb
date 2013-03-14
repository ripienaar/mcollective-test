module MCollective
  module Test
    class DataTest
      attr_reader :config, :logger, :plugin

      include Test::Util

      def initialize(data, options={})
        config = options.fetch(:config, {})

        ARGV.clear

        @config = create_config_mock(config)
        @logger = create_logger_mock

        @plugin = load_data(data, options[:data_file])
        @plugin.stubs(:ddl_validate).returns(true)
      end

      def load_data(data, data_file=nil)
        classname = "MCollective::Data::%s " % data.capitalize

        PluginManager.delete(data.downcase)

        if data_file
          raise("Cannot find data file %s for data plugin %s" % [data_file, data]) unless File.exist?(data_file)
          load data_file
        else
          PluginManager.loadclass(classname)
        end

        ddl = DDL::Base.new(data, :data, false)
        ddl.stubs(:dataquery_interface).returns(:output => {})

        DDL.stubs(:new).with(data, :data).returns(ddl)

        unless PluginManager.pluginlist.include?(data.downcase)
          PluginManager << {:type => data, :class => "MCollective::Data::%s" % data.capitalize, :single_instance => false}
        end

        PluginManager[data.downcase]
      end
    end
  end
end
