#!/bin/sh

rake db:migrate
rake setup:default_data
#rake setup:update_activated_date
rake migration:update_activated_date
