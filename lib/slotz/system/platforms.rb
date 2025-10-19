module Slotz

class System
module Platforms

end
end
end

Dir.glob( "#{File.dirname(__FILE__)}/**/*.rb" ).each do |platform|
    require platform
end
