# Concourse-Keygen

https://hub.docker.com/r/emcniece/concourse-keygen/

Sidekick for generating SSH keys for Concourse CI. This image creates the required SSH keys in a volumed directory and makes them available for use by the web and worker containers.

## Usage

The [official Concourse docker-compose instructions](https://concourse.ci/docker-repository.html) are self-explanatory. This image can be added to take care of the key generation step before running `docker-compose up`:

```yml
# New service:
concourse-keygen:
  image: emcniece/concourse-keygen
  volumes:
    - ./keydir:/concourse-keys

# Past here, the only change is the volumed directories

concourse-db:
  image: postgres:9.5
  environment:
    POSTGRES_DB: concourse
    POSTGRES_USER: concourse
    POSTGRES_PASSWORD: changeme
    PGDATA: /database

concourse-web:
  image: concourse/concourse
  links: [concourse-db]
  command: web
  ports: ["8080:8080"]
  volumes: ["./keydir/keys/web:/concourse-keys"]
  environment:
    CONCOURSE_BASIC_AUTH_USERNAME: concourse
    CONCOURSE_BASIC_AUTH_PASSWORD: changeme
    CONCOURSE_EXTERNAL_URL: "${CONCOURSE_EXTERNAL_URL}"
    CONCOURSE_POSTGRES_DATA_SOURCE: |-
      postgres://concourse:changeme@concourse-db:5432/concourse?sslmode=disable

concourse-worker:
  image: concourse/concourse
  privileged: true
  links: [concourse-web]
  command: worker
  volumes: ["./keydir/keys/worker:/concourse-keys"]
  environment:
    CONCOURSE_TSA_HOST: concourse-web

```

## Rancher

If you wish to use Concourse in Rancher, check out https://github.com/emcniece/rancher-catalog