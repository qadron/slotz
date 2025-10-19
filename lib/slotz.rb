module Slotz
    require_relative 'slotz/version'
    require_relative 'slotz/options'
    require_relative 'slotz/system'
    require_relative 'slotz/reservation'

    RESERVED = {
      disk:   0,
      memory: 0,
      cores:  0
    }

    def self.filter( reservation )
        # fail 'Max utilization.' if Slotz::System.max_utilization?

        if RESERVED[:disk] + reservation.disk <= System.disk_space_free
            RESERVED[:disk] += reservation.disk
        else
            fail 'Not enough disk resources.'
        end

        if RESERVED[:memory] + reservation.memory <= System.memory_free
            RESERVED[:memory] += reservation.memory
        else
            fail 'Not enough memory resources.'
        end

        # if RESERVED[:cores] + requirements[:cores] <= System.cores
        #     RESERVED[:cores]  += requirements[:cores]
        # else
        #     fail 'Not enough CPU resources.'
        # end
    end

end
