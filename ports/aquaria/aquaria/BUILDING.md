## Building notes

This is a build of AquariaOSE, see:

[https://github.com/AquariaOSE/Aquaria](https://github.com/AquariaOSE/Aquaria)

Thanks to Alec Holowka and Derek Yu for the beautiful game.


## Compile

```
# Ubuntu 20.04 focal
# sudo apt install libopenal-dev libsdl2-dev
# Or see src/Dockerfile

git clone https://github.com/AquariaOSE/Aquaria.git
cd Aquaria
# copy aquaria.patch from aquaria/src
patch -p1 < aquaria.patch
mkdir build && cd build
cmake .. -DAQUARIA_USE_SDL2=ON
make

# binary is Aquaria/build/aquaria
```
