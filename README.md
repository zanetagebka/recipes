# RECIPES APP README

Hi! 

I decided to do it this way (create model) and seed database.
In `files` folder you will see JSON file with recipes.
This file is used by service `app/services/recipe_service.rb` which reads it 
and allow to create table and seed it by data.

To setup project correctly you will need to follow these steps:

run `rake db:create` \
run `rake db:migrate` \
run `rake db:seed` 

OR simply run `rake prepare_project`

to run project use `rails s`

You can find working project under this url: 