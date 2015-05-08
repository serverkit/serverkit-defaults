require "serverkit"
require "serverkit/defaults"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end
