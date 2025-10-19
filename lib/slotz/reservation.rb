module Slotz

module Reservation

    def included( base )

        base.class_eval do

            attr_reader :disk
            attr_reader :memory
            attr_reader :cores

            def provision( provisions )
                @provisions = provisions
                @disk   = @provisions[:disk]
                @memory = @provisions[:memory]
                @cores  = @provisions[:cores]

                Slotz.filter self, @provisions

                ObjectSpace.define_finalizer(self, proc {
                    Slotz::RESERVED[:disk]   -= self.class.disk
                    Slotz::RESERVED[:memory] -= self.class.memory
                    Slotz::RESERVED[:cores]  -= self.class.cores
                })
            end

            def available_slots
                System.available_auto self
            end

            def available_slots_on_disk
                System.disk_space_free / disk
            end

            def available_slots_in_memory
                System.memory_free / memory
            end

        end

    end
    extend self

end

end
