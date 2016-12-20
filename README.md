# Phoenix Base

[![build status](https://gitlab.com/nikko.miu/phoenix_base/badges/master/build.svg)](https://gitlab.com/nikko.miu/phoenix_base/commits/master)
[![coverage report](https://gitlab.com/nikko.miu/phoenix_base/badges/master/coverage.svg)](https://gitlab.com/nikko.miu/phoenix_base/commits/master)

## Installation

Installation of this app is done through Docker containers. There is an application output that
can be used as well. However, the primary and recommended means of insallation are through Docker.

### Docker Build Expectations

Before jumping the gun and running `docker build .` you will need to get the application in the correct state. This is typically done through the CI process.

If you need to build the Docker image without using the CI build you will need to get the application in the right state. This is required because Docker builds the application based on a compiled version of the app with bundled and minified assets. Doing so keeps all of the development dependencies out of the Docker build image and thus keeps the image much lighter.

To create a Docker image you will need to run the following commands (after you have met the required development dependencies):

```bash
MIX_ENV=prod        # Set the Elixir env

npm install         # Install the Node.js dependencies
npm run deploy      # Compile and deploy the webpack assets
mix deps.get        # Get the application dependencies
mix compile         # Compile the application
mix phoenix.digest  # Hash all of theassets
mix release         # Create a release

unset MIX_ENV       # Unset the Elixir env
```

### Configuration

All of the deployment configuration files are located in the directory `/deploy` of the application repository.

### Database

Setup the database.
Run the migrations.

## Development

### Environment Variables

| Variable | Default |
| -------- | ------- |
| `SECRET_KEY_BASE` | `nil` |
| `DATABASE_URL` | `nil` |
| `POOL_SIZE` | `15` |
| `PORT` | `nil` |

### Dependencies

There are a handful of dependencies that are required to begin developing this application:

- `elixir-1.3.4`: Language used by the backend.
- `phoenix_framework-1.2.0`: Backend framework the app is built on.
- `inotify-tools`: Used for auto-reload to work properly in development mode. *(Optional)*
- `nodejs-lts`: Used for gathering dependencies and compiling assets for the client side.
- `webpack`: Used for compiling assets for the client side.
- `docker`: Required if you plan to build the Docker image for the application or want to use Postgres in a Docker container.
- `postgres`: The database engine used for the application. (App won't start without it)

#### Elixir

Use [the official guide](http://elixir-lang.org/install.html) to install Elixir for your environment.

**OS Package Manager Note**: Depending on your OS you may need to install the precompiled package to get the correct version of Elixir on your system.
**Debian-based Systems Note**: You might have to install the Erlang ESL:

```bash
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get install esl-erlang
```

#### Phoenix Framework

Use [the official guide](http://www.phoenixframework.org/docs/installation) to install Phoenix Framework.

#### inotify-tools

Use [this guide](https://github.com/rvoicilas/inotify-tools/wiki) to install `inotify-tools`.

#### Node.js

Install Node.js in the method that you are the most comfortable with. If you don't know how to install Node.js these are some guides that should help you get started:

- [Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-an-ubuntu-14-04-server)
- [Windows & Mac Installers](https://nodejs.org/en/download/)

#### Webpack

After Node.js is installed Webpack can be installed simply by running:

```bash
sudo npm install -g webpack
```

#### Docker

Use [the official guide](https://docs.docker.com/engine/installation/) to install Docker for your environment.
