require "init"
require "rack/hoptoad"

use Rack::Hoptoad, "cc8aa796ba335d9f24549349214a6c32"

Main.set :run, false
Main.set :environment, :production
Main.set :raise_errors, true

run Main
