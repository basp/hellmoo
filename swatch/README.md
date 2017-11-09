## swatch module
A swatch is just a stopwatch, a mechanism to keep track of time.

### reference
* `:create(message)` create a new swatch, it starts running immediately (give it some useful info by supplying a `message`)
* `:list()` list all running swatches
* `:duration(id)` get the duraction in seconds since you started the swatch
* `:destroy(id)` destroy the swatch