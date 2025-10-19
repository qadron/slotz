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
            @disk   = provisions[:disk]
            def self.disk
                @disk
            end

            @memory = provisions[:memory]
            def self.memory
                @memory
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
