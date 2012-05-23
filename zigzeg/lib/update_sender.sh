#!/usr/bin/env bash
#load rvm ruby
source /usr/local/rvm/environments/ruby-1.9.2-p290
cd /opt/apps/development/zigzeg/
rake cronjob:send_email_updates --trace
