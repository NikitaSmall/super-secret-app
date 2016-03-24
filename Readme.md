# githuber
Back-end junior uawebchallenge work.
Find a woking copy at the Heroku: https://githuber-uawebchallenge.herokuapp.com/
(sorry for slow work: free dyno)

## Technologies
1. Ruby as a language, Sinatra as a simple DSL for website tasks.
2. Mongo as a database, Mongoid as an adapter.
3. Rspec for tests, VSR to cache web requests during testing.
4. Heroku's scheduler extension used for daily caching system.

## About caching
Any request result will be saved to database at first attempt to get it,
but usualy all the data updates at the midnight by scheduler.
To save it to database you need to interact with this site usual way.

## Code review guide
1. To see routes and web app itself see `routes` folder and `application.rb` file.
2. Spec files placed in (obviously) `spec` folder. VCR cassettes prevent external requests to run and stored at `vcr_cassettes` folder.
3. The main classes are placed in `lib` folder. Here you can find classes that interact with github api, that parse requests and so on.
4. View and static files can be found in `views` and `public` folders.
5. Tasks for scheduler can be found in `Rakefile`

### To run this app locally you need to make two things:
1. Create `.env` file with `GITHUB_CLIENT_ID`, `GITHUB_CLIENT_SECRET` and `MONGOID_ENV` environment variables.
2. In `db` folder create and place `mongoid.yml` file (you may use `example.yml` as start point).
