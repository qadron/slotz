module Slotz
    require_relative 'slotz/version'
    require_relative 'slotz/options'
    require_relative 'slotz/system'
    require_relative 'slotz/loader'
    require_relative 'slotz/reservation'

    RESERVED = {
      disk:   0,
      memory: 0,
      cores:  0
    }

    def self.utilization
        disk   = RESERVED[:disk].to_f / System.disk_space_free
        memory = RESERVED[:memory].to_f / System.memory_free
        [disk, memory].max
    end

    def self.filter( klass )
        if !klass.is_a?( Class ) && !klass.is_a?( Module )
            klass = Object.const_get( klass.to_s )
        end

        return if !klass.respond_to?(:disk) || !klass.respond_to?(:memory)

        disk   = klass.disk
        memory = klass.memory

        if RESERVED[:disk].to_i + disk.to_i <= System.disk_space_free.to_i
            RESERVED[:disk] += disk.to_i
        else
            fail 'Not enough disk resources.'
        end

        if RESERVED[:memory].to_i + memory.to_i <= System.memory_free.to_i
            RESERVED[:memory] += memory.to_i
        else
            fail 'Not enough memory resources.'
        end

        # if RESERVED[:cores].to_i + cores.to_i <= System.cores.to_i
        #     RESERVED[:cores] += cores.to_i
        # else
        #     fail 'Not enough memory resources.'
        # end

        ObjectSpace.define_finalizer(klass, proc {
            Slotz::RESERVED[:disk]   -= klass.disk
            Slotz::RESERVED[:memory] -= klass.memory
            # Slotz::RESERVED[:cores]  -= klass.cores
        })

        {
            disk:   disk,
            memory: memory
            # cores:  0
        }
    end

end
