## Building

### Using Github Actions

Fork `https://github.com/ben-willmore/PortMaster-New/`

Enable Github Actions for your fork

Go to the Github Actions tab and choose `Build <portname>`

When complete, the new files will be committed to your fork, and a .zip file of the port will be available as a release.

### On a machine with docker
To build this port:

```
cd <portfolder>
mkdir build && cd build
cp ../src/* .

. ./docker-setup.txt port-build
```

In the docker container:
```
. build.txt
```

Back on the host machine:
```
cd <portfolder>
. ./build/retrieve-products ./build .
``
