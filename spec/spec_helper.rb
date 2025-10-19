require_relative 'support/helpers/paths'

Dir.glob( "#{support_path}/{lib,helpers,shared,factories}/**/*.rb" ).each { |f| require f }

RSpec::Core::MemoizedHelpers.module_eval do
    alias to should
    alias to_not should_not
end

RSpec.configure do |config|
    config.run_all_when_everything_filtered = true
    config.color = true
    config.add_formatter :documentation
    config.alias_example_to :expect_it
    config.filter_run_when_matching focus: true

    config.mock_with :rspec do |mocks|
        mocks.yield_receiver_to_any_instance_implementation_blocks = true
    end

    config.before( :each ) do
        # reset_all
    end

    config.after( :each ) do
        # cleanup_instances
        # processes_killall
    end
    config.after( :all ) do
        # killall
    end
end
