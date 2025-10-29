module Slotz

module Reservation

    def provision( base, resources )
        base.class_eval do
            self.class.attr_accessor :_slotz_disk
            self.class.attr_accessor :_slotz_memory
            self.class.attr_accessor :_slotz_cores

            def initialize(*)
                super
                Slotz.filter self.class
            end

            def available_slots
                System.available_auto self
            end

            def available_slots_on_disk
                System.disk_space_free / self.class._slotz_disk
            end

            def available_slots_in_memory
                System.memory_free / self.class._slotz_memory
            end
        end

        base._slotz_disk   = resources[:disk]
        base._slotz_memory = resources[:memory]
    end
    extend self

end

end
