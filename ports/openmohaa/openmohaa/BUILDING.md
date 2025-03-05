git clone https://github.com/openmoh/openmohaa.git

cd openmohaa
mkdir build-mohaa && cd build-mohaa
cmake -G Ninja ..
ninja
ninja install

# retrieve build products on host machine
docker cp openmohaa-build:/usr/local/lib/openmohaa .

