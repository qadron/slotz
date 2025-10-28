# Slotz

A resource management library for Ruby, an assistance to help you keep your resource (disk, memory) 
requirements healthy.

## Reservations

Reserve the amount of resources your application needs, and move forward accordingly.

You can stop allocating resources upon getting an exception indicating insufficient resources
of any type.

```ruby
require 'slotz'

class MyApp

    Slotz::Reservation.provision( 
      self,
      disk:   1 * 1_000_000_000, # bytes
      memory: 5 * 1_000_000_000 #
    )

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

versus:

```ruby
require 'slotz'

class MyApp
    Slotz::Reservation.provision( 
        self,
        disk:   99 * 1_000_000_000, # bytes
        memory: 50 * 1_000_000_000 #
    )
end

my_app = MyApp.new

p my_app.available_slots
#=> 1

p my_app.available_slots_on_disk
#=> 13

p my_app.available_slots_in_memory
#=> 1

p Slotz.utilization
#=> 0.911408461062344
```

## Process loading/spawning

In order to still allow for `spawn`/`loader` functionality to be accommodated, you can spawn or load
your file of interest accordingly, and still maintain the desired resource management.

This can be the file you wish to load:

### `child.rb:`

```ruby
p $options # Pre-set options.
# => {:my=>:option, :ppid=>3407092, :tmpdir=>"/tmp"}

class Child
    Slotz::Reservation.provision( 
        self,
        disk:   1 * 1_000_000_000,
        memory: 5 * 1_000_000_000
    )
end
# Just load for the inside view. don't run anything.
exit if $options.nil?

# Load everything to run. 
# [...]

```

### `loader.rb:`
```ruby
require 'slotz'

loader = Slotz::Loader.new
loader.load( 'Child', "tmp/test/child.rb", { my: :option } )
```
