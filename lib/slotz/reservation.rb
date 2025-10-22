module Slotz

module Reservation

    def included( base )
        base.class_eval do
            self.class.attr_accessor :disk
            self.class.attr_accessor :memory
            self.class.attr_accessor :cores

            Slotz.filter base

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

    end
    extend self

end

end
