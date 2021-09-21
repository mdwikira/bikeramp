# README

## How to run

This API is run like any other rails app with `rails server`. Remember to to `bundle install` before. In development mode it uses `sqlite` database, so you don't have to configure any connections right off the bat.

Tests are run with `rails test`. 

**IMPORTANT** : 
This API makes use of Google services to handle finding distance between given addresses. 
Because of this an environment variable called `GOOGLE_MAPS_API_KEY` has to be configured containing a valid API key.



