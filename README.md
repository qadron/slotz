# Slotz

A resource management library for Ruby, an assistance to help you keep your resource (disk, memory) 
requirements healthy.

## Reservations

Reserve the amount of resources your application needs, and move forward accordingly.
You can stop allocating applications once you get an exception indicating insufficient resources.

```ruby
require 'slotz'

class MyApp
    # Each instantiation must pass this reservation.
    include Slotz::Reservation.new(
      disk:   1 * 1_000_000_000,
      memory: 2 * 1_000_000_000
    )
end

my_app = MyApp.new

p my_app.class.available_slots
#=> 27

p my_app.class.available_slots_on_disk
#=> 1425

p my_app.class.available_slots_in_memory
#=> 27
```
