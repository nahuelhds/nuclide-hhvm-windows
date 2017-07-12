[![Docker Automated build](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg)](https://hub.docker.com/r/joseajp/nuclide-remote/)

# nuclide-hhvm-windows
Remote Nuclide Server & HHVM in a Docker container for Windows usage with Nuclide Remote Project Folder functionality. You can obtain more information about Nuclide at https://nuclide.io/docs/features/remote/

The goal of this project is to **code Hack in Windows** with Nuclide and be able to run the `hh_client` through the *Remote Project Folder* functionality

> **CREDITS**
>
> This repo is strongly based on the work done by **joseajp** in his [nuclide-remote repo](https://github.com/joseajp/nuclide-remote).

## TL;DR
HHVM doesn't work on Windows yet and my goal was to be able to work with Nuclide and the HHVM Client (hh_client) in order to be able to lint my Hack code. So, making use of the Remote Project functionality and thought that maybe by connecting remotely to a Docker Image with Nuclide Remote and HHVM I could make it work. That worked like a charm.

## Usage

1. Clone this repo wherever you want.
1. Build the Docker image.
1. Run the image you've just built.
1. Connect remotely with Nuclide to the available `/projects` folder
1. Work as usual.

### Build and run
In command line would be:
```bash
cd /path/to/the/cloned-repo
docker build . --tag $TAG
docker run -d -p 9090:9090 -p 9091:22 -v $SRC_WWW:/projects --name $CONTAINER $TAG
```

In my case, `$TAG` is __nhw__, `$CONTAINER` is __nhw0__ and `$SRC_WWW` is __D:/wamp64/www__. So...

```bash
docker build . --tag nhw
docker run -d -p 9090:9090 -p 9091:22 -v D:/wamp64/www:/projects --name nhw0 nhw
```

**IMPORTANT:** you have to share the drive in order to give the image access to it. You can do that in *Docker / Settings / Shared Drives*, then check the ones you wanna share and apply the changes.

#### How to run the Docker image with multiple source folders?
In case you have many folders with your projects distributed in your local machines, you can use the `-v` several times and define a subfolder for each. For instance, I have my backend projects at **D:/wamp64/www** and my frontend projects at **D:/dev**, so I run:


```bash
docker run -d -p 9090:9090 -p 9091:22 -v D:/wamp64/www:/projects/backend -v D:/dev:/projects/frontend --name nhw0 nhw
```

### Nuclide remote connection
Once you have the image running in Docker, go to your local machine and:

* Open Atom + Nuclide.
* In the Tree view, click on the **Add Remote Project Folder**.
* Introduce the following settings:
  * **Username** - `root`
  * **Server** - `localhost` or `127.0.0.1`
  * **Initial Directory** - `/projects/<your-project-folder>`
  * **SSH Port** - `9091`
  * **Password** - `nuclide`
  * **Remote Server Command** - `nuclide-start-server --port 9090`

## Handling the container
Some useful Docker commands:

```bash
# Access to the container bash
# docker exec -it $CONTAINER $CMD
docker exec -it nhw0 bash

# Stop the docker container
# docker stop $CONTAINER
docker stop nhw0
```

## You're done
You can now start coding your project on Windows and make use of the HHVM Client

## License

This repository is licensed under the terms of the MIT [LICENSE](LICENSE).
