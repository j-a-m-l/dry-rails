# docker-rails
This `docker-compose.yml` installs RoR.


# Environments
The root `docker-compose.yml` is the base of the environment specific configurations, so it does not links containers, nor creates the volumes.

* All the environments have a `.env` file that defines the `PostgreSQL` credentials.

## Development
Exposes ports 980 and 9443, so it should not conflict with your local servers.
`docker-compose -f ./environments/development/docker-compose.yml up -d`

## Production
Exposes ports 80 and 443.
`docker-compose -f ./environments/production/docker-compose.yml up -d`


# Data
Includes the PostgreSQL data.


# Web
Includes the RoR application.


# Configuration

The main `Dockerfile` installs Rails.

## Installation configuration

## Nginx
The `config/nginx` folder includes the base Nginx configuration that is used in the `server` container.

## PostgreSQL
The `config/postgresql` folder includes the base PostgreSQL configuration that is used in the `server` container.


# Authors
Juan A. Martín Lucas (https://github.com/j-a-m-l).


# License
This project is licensed under the MIT license. See [LICENSE](LICENSE) for details.
