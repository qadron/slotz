require_relative 'mixins/unix'

module Slotz

class System
module Platforms
class Linux < Base
    include Mixins::Unix

    # @return   [Integer]
    #   Amount of free RAM in bytes.
    def memory_free
        memory.available_bytes
    end

    class <<self
        def current?
            Slotz::System.linux?
        end
    end

end

end
end
end
