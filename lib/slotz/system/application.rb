module Slotz

    class Application

        attr_reader :klass
        attr_reader :requirements

        def initialize( klass, requirements = {} )
            @klass        = klass
            @requirements = requirements

            Slotz.occupy self
        end

        def disk
            @requirements[:disk]
        end

        def remaining_disk

        end

        def cores
            @requirements[:cores]
        end

        def remaining_cores

        end

        def memory
            @requirements[:memory]
        end

        def remaining_memory

        end
    end

end
