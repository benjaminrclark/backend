require 'json'
require 'sinatra'

set :bind, '0.0.0.0'

set :logging, true
 
get '/' do
  message = { 
    :variable =>ENV.fetch("VARIABLE","variable"),
    :git_short_commit =>ENV.fetch("GIT_SHORT_COMMIT","git_short_commit"),
    :branch =>ENV.fetch("BRANCH","branch"),
    :node =>ENV.fetch("NODE","node")
  }.to_json
end
