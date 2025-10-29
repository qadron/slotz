module Slotz

module Reservation

    def provision( base, resources )
        base.class_eval do
            self.class.attr_accessor :disk
            self.class.attr_accessor :memory
            self.class.attr_accessor :cores

            def initialize(*)
                super
                Slotz.filter self.class
            end

            def available_slots
                System.available_auto self
            end

            def available_slots_on_disk
                System.disk_space_free / self.class.disk
            end

            def available_slots_in_memory
                System.memory_free / self.class.memory
            end
        end

        base.disk   = resources[:disk]
        base.memory = resources[:memory]
    end
    extend self

end

end
