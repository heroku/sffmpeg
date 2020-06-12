# Static FFmpeg Build

[![Build Status](https://travis-ci.org/pyke369/sffmpeg.svg?branch=master)](https://travis-ci.org/pyke369/sffmpeg)

`sffmpeg` is a simple cmake-based full-featured FFmpeg build helper.

It currently works on Linux, OpenBSD, FreeBSD, and MacOSX. It has been tested the most heavily on Linux/x86_64 (Ubuntu 14.04).
The helper will grab the latest versions of most FFmpeg dependencies, providing a way to effectively build, test and compare
multiple builds of FFmpeg on the same host.

## Requirements

`sffmpeg` requires:

- a POSIX-compliant system (virtually any system today).
- a recent version of [gcc](http://gcc.gnu.org/).
- a recent version of [cmake](http://www.cmake.org/) (2.8.8+, with proper git and mercurial bindings).
- the [autoconf](http://www.gnu.org/software/autoconf/) and [libtool](http://www.gnu.org/software/libtool/) utilities.
- the [pkg-config](http://www.freedesktop.org/wiki/Software/pkg-config) utility.

## Usage

Just type the following commands at the shell prompt:

    $ git clone https://github.com/heroku/sffmpeg
    $ docker build -t heroku/sffmpeg .
    $ docker run heroku/sffmpeg /bin/bash -c "make"

Then go grab a coffee (or maybe two). The helper will download and compile all FFmpeg dependencies for you.
Once done, you should get a FFmpeg binary in the `build/bin` directory (with all dependencies statically linked-in).


    ffmpeg version 3.0 Copyright (c) 2000-2016 the FFmpeg developers
      libavutil      55. 17.103 / 55. 17.103
      libavcodec     57. 24.102 / 57. 24.102
      libavformat    57. 25.100 / 57. 25.100
      libavdevice    57.  0.101 / 57.  0.101
      libavfilter     6. 31.100 /  6. 31.100
      libswscale      4.  0.100 /  4.  0.100
      libswresample   2.  0.101 /  2.  0.101
      libpostproc    54.  0.100 / 54.  0.100
    Hyper fast Audio and Video encoder
    usage: ffmpeg [options] [[infile options] -i infile]... {[outfile options] outfile}...

    Use -h to get full help or, even better, run 'man ffmpeg'


From there, you may use the binary immediately or build a Debian package for later deployment (see below).

## Packaging

(requires devscripts package)

You may optionally build a Debian package by typing the following command at the shell prompt:

    $ docker run heroku/sffmpeg /bin/bash -c "make deb"

The `ffmpeg`, `ffprobe` and `frmxtract` binaries will be installed by the package in the `/usr/bin` directory.

    $ sudo dpkg -i sffmpeg_3.0_amd64.deb
    Selecting previously unselected package sffmpeg.
    Unpacking sffmpeg (from sffmpeg_3.0_amd64.deb) ...
    Setting up sffmpeg (3.0) ...

## Updating

When upgrading the version of FFmpeg in use, the minimum required for the pull request is:

* Download the latest ffmpeg release and replace the existing one in the `vendor` directory
* Modify `CMakeLists.txt` to point to the new vendored ffmpeg release. 
* Modify `debian/changelog` file to bump the version number for the package. 

If building ffmpeg fails with a simple upgrade described above, or other dependencies need to be updated as well, you will need to perform the first two steps above for each of the other dependencies. Occasionally those other dependencies will include major version upgrades which require more detailed changes to the CMake configuration for the dependency itself, as well as ffmpeg. Take special care to do thorough testing to make sure the project not only still builds, but the package works on the Heroku stack images!

## S3 Upload

Once any Pull Request is merged into `master`, the `.deb` package is automatically uploaded by CircleCI to the S3 bucket used by the [Heroku Active Storage Preview Buildpack](https://github.com/heroku/heroku-buildpack-activestorage-preview/). 

Be sure that any PRs bump the version number in the `changelog` so that your new version does not overwrite the existing version in use by users of that buildpack. 

You will need to submit a PR in the buildpack repo to bump the `SFFMPEG_VERSION` in `bin/compile`. Be sure to use your PR branch on the buildpack to deploy some [test apps](https://github.com/heroku/active_storage_with_previews_example) with the new build and make sure nothing is broken.