# Mystery lunch matching application

# How to run

1. Build docker images with docker compose
```bash
docker-compose build --no-cache
```

2. Install libraries
```bash
docker-compose run --rm rails bundle install --path "vendor/bundle"
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

