# docker-makemkv

This container will allow you to build the [MakeMKV][MakeMKV]
GUI and CLI tools without dumping the build dependencies on your system.  
  
This build tool is configured to use the latest FFMPEG and libavcodec libraries
since most distributions come with outdated versions.  In practical terms this
means you will be able to handle 24-bit FLAC audio encoding as well as DTS-HD decoding.  
  
## Pre-Requisites

Obviously, you will need a working installation of [docker][docker] to build the
container.

## Usage

Running the build process is pretty straightforward.  Clone the repo, run the
build script, and a docker container will spin up to produce the build artifacts.
```
$ git clone git@github.com:Kmagameguy/docker-makemkv.git
$ cd docker-makemkv
$ ./build.sh
```

If successful the process will create a new `build/` folder inside the `docker-makemkv` root folder.
Inside the build folder will be the GUI util `makemkv` and the CLI util `makemkvcon`.
Move both to your `/usr/bin` folder and if your $PATH is set properly the
commands should become immediately usable.  For example, you can invoke the GUI
by simply running `makemkv`.

[MakeMKV]:https://www.makemkv.com
[docker]:https://docs.docker.com/engine/install/
