# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "LibpcapBuilder"
version = v"1.9.0"

# Collection of sources required to build LibpcapBuilder
sources = [
    "http://www.tcpdump.org/release/libpcap-1.9.0.tar.gz" =>
    "2edb88808e5913fdaa8e9c1fcaf272e19b2485338742b5074b9fe44d68f37019",

    "http://www.linuxfromscratch.org/patches/blfs/svn/libpcap-1.9.0-enable_bluetooth-1.patch" =>
    "5000de2daec00fb31ccc949f7e265bfb621635c8e2daf9bb17770d75997195b5",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd libpcap-1.9.0/
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain
make -j${nproc}
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    FreeBSD(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libpcap", :libpcap)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

