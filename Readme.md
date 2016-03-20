# githuber
Back-end junior uawebchallenge work.

## Technologies
1. Ruby as a language, Sinatra as a simple DSL for website tasks.
2. Mongo as a database, Mongoid as an adapter.
3. Rspec for tests, VSR to cache web requests during testing.

## About caching
Any request result will be saved to database at first attempt.
To save it to database you need to interact with this site usual way.
I didn't create any scheduled works due they are useless with Heroku free account
(but it is good solution for caching our data anyway): application will go asleep
after thirty minutes of idle and nothing will be done. So, where you will make first
request, please, wait a little bit for slow free Heroku app will done all the work.
There is four different requests that can be performed each day,
but only three will be different:
- Apps created last week / apps' activity for last week
- Apps created last week / apps' activity for last month (result will be the same as first one, this state is checked)
- Apps created last month / apps' activity for last week
- Apps created last month / apps' activity for last month

### Personal comment
This task shows perfectly typical N+1 query problem to external API
with huge side computing.
I may be wrong but I think that such kinds of clever/tricky tasks fits perfectly
when we can design our API. Anyway, the task is comlete.
