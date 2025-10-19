require_relative 'mixins/unix'

module Slotz

class System
module Platforms
class OSX < Base
    include Mixins::Unix

    # @return   [Integer]
    #   Amount of free RAM in bytes.
    def memory_free
        pagesize * memory.free
    end

    class <<self
        def current?
            Slotz::System.mac?
        end
    end

end
end
end
end
