# Mystery lunch matching application

# How to run

1. Build docker images with docker compose
```bash
docker-compose build
docker-compose up # this will create required containers but fails
```

2. Install libraries
```bash
docker-compose run --rm rails bundle install
docker-compose run --rm rails yarn install
```

3. Prepare db
In a different terminal, run the following:

```bash
docker-compose run --rm rails bundle exec rails db:create
docker-compose run --rm rails bundle exec rails db:migrate
docker-compose run --rm rails bundle exec rails db:seed
```

4. Run web service
Once you run all required tasks you able to run rails development environment on docker.
```bash
docker-compose up
```

# Matching logic

Matching logic is select users based on users possible connection with other users.
It will start to choose users from lowest connection of users. And this will prepend to user
stay without selection.

Logic complexity is O(n^2) which loop all N numbers users twice. 

More about: app/services/mystery_matcher.rb

**Benchmark test**


1000 users

```bash
                    user     system      total        real
Mystery matching  0.742561   0.008291   0.750852 (  0.754114)
                  0.742561   0.008291   0.750852 (  0.754114)
```

10_000 users

```bash
       user     system      total        real
Mystery matching
      74.757023   1.552273  76.309296 ( 77.806297)
      74.757023   1.552273  76.309296 ( 77.806297)
```

### BUGFIX ###

Converting to old partner data into hash only storing to single user from multiple partner data.
I should find another quick accessible way to convert that data.
Query or Another search by loop will increase complexity to O(n^3)

## How it runs

Sidekiq scheduled job will run it every 1st day of each month.
Data will be stored into MysteryPair table as self joined table.


