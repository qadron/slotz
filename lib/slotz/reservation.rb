module Slotz

class Reservation < Module

    attr_reader :disk
    attr_reader :memory
    attr_reader :cores

    def initialize( provision )
        @provision = provision

        ObjectSpace.define_finalizer(self, proc {
            Slotz::RESERVED[:disk]   -= self.class.disk
            Slotz::RESERVED[:memory] -= self.class.memory
            Slotz::RESERVED[:cores]  -= self.class.cores
        })
    end

    def included( base )
        provisions = @provision
        base.class_eval do

            def self.available_slots
                System.available_auto self
            end

            @disk   = provisions[:disk]
            def self.disk
                @disk
            end
            def self.available_slots_on_disk
                System.disk_space_free / disk
            end

            @memory = provisions[:memory]
            def self.memory
                @memory
            end
            def self.available_slots_in_memory
                System.memory_free / memory
            end

            @cores  = provisions[:cores]
            def self.cores
                @cores
            end
        end

        Slotz.filter base
    end

end

end
