# README

## How to run

This API is run like any other rails app with `rails server`. Remember to to `bundle install` before. In development mode it uses `sqlite` database, so you don't have to configure any connections right off the bat.

Tests are run with `rails test`. 

**IMPORTANT** : 
This API makes use of Google services to handle finding distance between given addresses. 
Because of this an environment variable called `GOOGLE_MAPS_API_KEY` has to be configured containing a valid API key.

## Examples

```
 curl -X POST http://localhost:3000/api/trips -H 'Content-Type: application/json' -d '{"start_address":"Szmaragdowa 36, Lublin, Polska", "end_address":"Onyksowa 7, Lublin, Polska", "price": "12.50", "date":"2021-09-12"}'
```

```
curl -X GET http://localhost:3000/api/stats/monthly
```

```
curl -X GET http://localhost:3000/api/stats/weekly
```