#! /bin/bash
bundle check || bundle install

bundle exec rake db:create
bundle exec rake db:migrate

rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0
