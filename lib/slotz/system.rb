require_relative 'system/platforms/base'
require 'singleton'
require 'set'

module Slotz

class System
    include Singleton

    # @return   [Bool]
    def self.windows?
        @is_windows ||= Gem.win_platform?
    end

    # @return   [Bool]
    def self.linux?
        @is_linux ||= RbConfig::CONFIG['host_os'] =~ /linux/
    end

    # @return   [Bool]
    def self.mac?
        @is_mac ||= RbConfig::CONFIG['host_os'] =~ /darwin|mac os/i
    end

    # @return   [Array<Platforms::Base>]
    attr_reader :platforms

    # @return   [Slots]
    attr_reader :slots

    attr_accessor :max_slots

    def initialize
        @platforms = []
        @pids      = Set.new
    end

    def use( pid )
        @pids << pid
        pid
    end

    # @return   [Integer]
    #   Amount of new applications that can be safely run in parallel, currently.
    #   User option will override decision based on system resources.
    def available
        # Manual mode, user gave us a value.
        if (max_slots = System.max_slots)
            max_slots - used

        # Auto-mode, pick the safest restriction, RAM vs CPU.
        else
            available_auto
        end
    end

    # @return   [Integer]
    #   Amount of new applications that can be safely run in parallel, currently.
    #   The decision is based on the available resources alone.
    def available_auto( requirements )
        [ available_in_memory( requirements[:memory] ),
          available_in_cpu( requirements[:cores] ),
          available_in_disk( requirements[:disk] ) ].min
    end

    # @return   [Integer]
    #   Amount of instances that are currently alive.
    def used
        Slotz.applications.size
    end

    # @return   [Integer]
    #   Amount of scans that can be safely run in parallel, in total.
    def total
        used + available
    end

    def fits?( requirements )
        available_auto( requirements )
    end

    # @return   [Integer]
    #   Amount of processes we can fit into the available memory.
    #
    #   Works based on slots, available memory isn't currently available OS
    #   memory but memory that is unallocated.
    def available_in_memory( memory )
        return Float::INFINITY if memory.to_i == 0
        (unallocated_memory / memory).to_i
    end

    # @return   [Integer]
    #   Amount of CPU cores that are available.
    #
    #   Well, they may not be really available, other stuff on the machine could
    #   be using them to a considerable extent, but we can only do so much.
    def available_in_cpu( cores )
        @system.cpu_count - used
    end

    # @param    [Integer]   pid
    #
    # @return   [Integer]
    #   Remaining memory for the scan, in bytes.
    def remaining_memory_for( pid )
        [memory_size - @system.memory_for_process_group( pid ), 0].max
    end

    # @return   [Integer]
    #   Amount of memory (in bytes) available for future scans.
    def unallocated_memory
        # Available memory right now.
        available_mem = @system.memory_free

        # Remove allocated memory to figure out how much we can really spare.
        @pids.each do |pid|
            # Mark the remaining allocated memory as unavailable.
            available_mem -= remaining_memory_for( pid )
        end

        available_mem
    end

    # @param    [Integer]   pid
    #
    # @return   [Integer]
    #   Remaining disk space for the scan, in bytes.
    def remaining_disk_space_for( pid )
        [disk_space - @system.disk_space_for_process( pid ), 0].max
    end

    # @return   [Integer]
    #   Amount of disk space (in bytes) available for future scans.
    def unallocated_disk_space
        # Available space right now.
        available_space = @system.disk_space_free

        # # Remove allocated space to figure out how much we can really spare.
        # @pids.each do |pid|
        #     # Mark the remaining allocated space as unavailable.
        #     available_space -= remaining_disk_space_for( pid )
        # end

        available_space
    end

    def disk_space_requirement( application )
        application.disk.to_i
    end

    # @return   [Fixnum]
    #   Amount of memory (in bytes) to allocate.
    def memory_requirement( application )
        application.memory.to_i
    end

    # @return   [Integer]
    #   Amount of free RAM in bytes.
    def memory_free
        platform.memory_free
    end

    # @param    [Integer]   pgid
    #   Process group ID.
    #
    # @return   [Integer]
    #   Amount of RAM in bytes used by the given GPID.
    def memory_for_process_group( pgid )
        platform.memory_for_process_group( pgid )
    end

    # @return   [Integer]
    #   Amount of free disk space in bytes.
    def disk_space_free
        platform.disk_space_free
    end

    # @return   [String
    #   Location for temporary file storage.
    def disk_directory
        platform.disk_directory
    end

    # @param    [Integer]   pid
    #   Process ID.
    #
    # @return   [Integer]
    #   Amount of disk space in bytes used by the given PID.
    def disk_space_for_process( pid )
        platform.disk_space_for_process( pid )
    end

    # @return   [Integer]
    #   Amount of CPU cores.
    def cpu_count
        @cpu_count ||= platform.cpu_count
    end

    # @return   [Platforms::Base]
    def platform
        return @platform if @platform

        platforms.each do |klass|
            next if !klass.current?

            return @platform = klass.new
        end

        raise "Unsupported platform: #{RUBY_PLATFORM}"
    end

    # @private
    def register_platform( platform )
        platforms << platform
    end

    # @private
    def reset
        @pids.clear
        @cpu_count = nil
        @platform  = nil
    end

    class <<self
        def method_missing( sym, *args, &block )
            if instance.respond_to?( sym )
                instance.send( sym, *args, &block )
            else
                super( sym, *args, &block )
            end
        end

        def respond_to?( *args )
            super || instance.respond_to?( *args )
        end
    end

end
end

require_relative 'system/platforms'
