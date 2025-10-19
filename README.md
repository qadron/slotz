# Slotz

A resource management library for Ruby, an assistance to help you keep your resource (disk, memory) 
requirements healthy.

## Reservations

Reserve the amount of resources your application needs, and move forward accordingly.
You can stop allocating applications once you get an exception indicating insufficient resources.

```ruby
require 'slotz'

class MyApp
    # Add system accounting capabilities.
    include Slotz::Reservation

    def initialize
        super

        # Each instantiation must pass this reservation.
        provision(
          disk:   1 * 1_000_000_000, # bytes
          memory: 5 * 1_000_000_000 # bytes
        )
    end

end

my_app = MyApp.new

p my_app.available_slots
#=> 11

p my_app.available_slots_on_disk
#=> 1425

p my_app.available_slots_in_memory
#=> 11

p Slotz.utilization
#=> 0.08933773478082488 %
```
