set :user, "danbooru"
set :rails_env, "production"
server "localhost", :roles => %w(web app db), :primary => true
#~ set :user, "albert"
#~ set :rails_env, "production"
#~ server "sonohara.donmai.us", :roles => %w(web app db), :primary => true, :user => "albert"
#~ server "hijiribe.donmai.us", :roles => %w(web app), :user => "albert"
