## delay module
A delay is equivalent to setting up a `tempTimer` in **Mudlet** but just a little bit easier to work with.

### reference
* `:create(seconds, code)` will create a new delay that executes `code` after `seconds` seconds.
* `:destroy(id)` destroy the suspended delay with id `id` (use `:list()` to find out the value for `id`)
* `:list()` lists information about all suspensded delays