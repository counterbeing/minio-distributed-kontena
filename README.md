# [Minio](https://www.minio.io/) for Distribution on [Kontena](https://www.kontena.io/)

If you're here, you probably know why you're interested in this already. But just in case: [Minio](https://www.minio.io/) is basically Amazon S3, but as an open source microservice. It's capable of being installed between many hosts, and storing data on many drives. The tricky bit in terms of using Minio with [Kontena](https://www.kontena.io/) is finding the other minio peers.

## How I've solved this problem here:

- Defer the decision until after boot
- Let Kontena keep track of where the other instances are in etcd, and use those... this may prove to be unstable.
- Reconfigure Minio any time servers appear or disappear. I don't know what effect this could have if several servers go on and offline. Data loss?

## Usage

This can be used in kontena like so. Make sure you store the necessary secrets in your vault.

```yaml
version: '2'
name: app
stack: somestack

services:
  load_balancer:
    image: kontena/lb:latest
    deploy:
      strategy: daemon
    ports:
      - 9000:9000

minio:
  stateful: true
  image: corylogan/minio-distributed-kontena
  # Multiples of 2
  instances: 4
  command: /entrypoint.sh
  secrets:
    - secret: MINIO_ACCESS_KEY
      name: MINIO_ACCESS_KEY
      type: env
    - secret: MINIO_SECRET_KEY
      name: MINIO_SECRET_KEY
      type: env
  environment:
    - KONTENA_LB_MODE=http
    - KONTENA_LB_BALANCE=roundrobin
    - KONTENA_LB_INTERNAL_PORT=9000
    - KONTENA_LB_EXTERNAL_PORT=9000
    - KONTENA_LB_VIRTUAL_HOSTS=your.host.name
    - KONTENA_LB_CUSTOM_SETTINGS=redirect scheme https if !{ ssl_fc }
  links:
    - load_balancer
  ```


## Testing
I currently test a few bash functions. Just run `./test.sh`. These are more for dev purposes than anything else, and it really doesn't test the actual loop.
