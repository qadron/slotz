require 'base64'

module Slotz
class Loader

    RUNNER = "#{File.dirname( __FILE__ )}/loader/base.rb"

    def initialize
        # Monitor pids to adjust slotz utilization, fool finalizer to account for dead pids.
        @pids = {}
    end

    # @param    [String]    executable
    #   Name of the executable Ruby script found in {OptionGroups::Paths#executables}
    #   without the '.rb' extension.
    # @param    [Hash]  options
    #   Options to pass to the script -- can be retrieved from `$options`.
    #
    # @return   [Integer]
    #   PID of the process.
    def load( klass, executable, options = {} )
        if !File.exist? executable
            fail "File does not exist: #{executable}"
        end

        require_relative executable
        Slotz.filter klass

        stdin      = options.delete(:stdin)
        stdout     = options.delete(:stdout)
        stderr     = options.delete(:stderr)
        new_pgroup = options.delete(:new_pgroup)
        daemonize  = options.delete(:daemonize)

        spawn_options = {}

        if new_pgroup
            spawn_options[:pgroup] = new_pgroup
        end

        spawn_options[:in]  = stdin  if stdin
        spawn_options[:out] = stdout if stdout
        spawn_options[:err] = stderr if stderr

        options[:ppid]   = Process.pid
        options[:tmpdir] = Dir.tmpdir

        encoded_options = Base64.strict_encode64( Marshal.dump( options ) )
        argv            = [executable, encoded_options]

        # It's very, **VERY** important that we use this argument format as
        # it bypasses the OS shell and we can thus count on a 1-to-1 process
        # creation and that the PID we get will be for the actual process.
        pid = Process.spawn(
          {
            'SLOTZ_SPAWN_OPTIONS' => Base64.strict_encode64( Marshal.dump( {} ) )
          },
          RbConfig.ruby,
          RUNNER,
          *(argv + [spawn_options])
        )

        if !daemonize
            begin
                Process.waitpid( pid )
            rescue Errno::ECHILD
                @pids.delete pid
                return
            rescue Interrupt
                exit 0
            end
        end

        pid
    rescue => e
        p e
        e.backtrace.each do |l|
            p l
        end
    end


end
end
