# [Minio](https://www.minio.io/) for Distribution on [Kontena](https://www.kontena.io/)

If you're here, you probably know why you're interested in this already. But just in case: [Minio](https://www.minio.io/) is basically Amazon S3, but as an open source microservice. It's capable of being installed between many hosts, and storing data on many drives. The tricky bit in terms of using Minio with [Kontena](https://www.kontena.io/) is finding the other minio peers.

## How I've solved this problem here:

- Defer the decision until after boot
- Let Kontena keep track of where the other instances are in etcd, and use those... this may prove to be unstable.
- Reconfigure Minio any time servers appear or disappear. I don't know what effect this could have if several servers go on and offline. Data loss?


# Testing
I currently test a few bash functions. Just run `./test.sh`
