# Building

To build Legobot on Docker, bundled with an ``ngircd`` IRC server, run the following command in repository root:

```
$ sudo docker build -t local-legobot .
```

This builds an Ubuntu 14.04 (LTS) Docker image bundled with an ngircd IRC server with SSL support.
Legobot is installed at ``/legobot`` and ngircd certificates are installed in ``/ngircd``.
Container entrypoint is ``supervisord``, which starts both these services.

# Running

Run the following command to run the container locally:

```
$ sudo docker run -d -p 127.0.0.1:6667:6667 -p 127.0.0.1:6697:6697 local-legobot
```

To expose ports to external clients run the container without binding to localhost:

```
$ sudo docker run -d -p 6667:6667 -p 6697:6697 local-legobot
```
