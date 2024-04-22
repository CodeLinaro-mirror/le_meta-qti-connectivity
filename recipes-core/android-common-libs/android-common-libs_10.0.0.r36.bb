DESCRIPTION = "Different utilities libraries from Android"
SECTION = "console/utils"
LICENSE = "Apache-2.0 & MIT"
LIC_FILES_CHKSUM = " \
    file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10 \
    file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
"
inherit clang
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "libbsd libpcre zlib libcap p7zip"
RDEPENDS:${PN} += "lib7z.so()(64bit)"

# matches with 10.0.0+r36
SRCREV_core = "5aa13b053182b758d7a19db0c83e1b9b5bf1ec2e"
SRCREV_libunwind = "03a963ecf6ea836b38b3537cbcda0ecfd7a77393"
SRCREV_FORMAT = "core_libunwind"

SRC_URI = " \
    git://salsa.debian.org/android-tools-team/android-platform-system-core.git;name=core;protocol=https;nobranch=1;destsuffix=git/system/core \
    git://salsa.debian.org/android-tools-team/android-platform-external-libunwind.git;protocol=https;name=libunwind;nobranch=1;destsuffix=git/external/libunwind \
    file://libbase_mk_change_out_dir.patch \
    file://libcutils_mk_change_out_dir.patch \
    file://liblog_mk_change_out_dir.patch \
    file://libbacktrace_mk_change_out_dir.patch \
    file://libunwind_mk_change_out_dir.patch \
    file://libutils-mk-change-out-dir.patch \
    file://use_name_space_std_to_compile_libbacktrace.patch \
    file://rules_yocto.mk;subdir=git \
"

S = "${WORKDIR}/git"
B = "${WORKDIR}/${BPN}"

# http://errors.yoctoproject.org/Errors/Details/1debian881/
ARM_INSTRUCTION_SET:armv4 = "arm"
ARM_INSTRUCTION_SET:armv5 = "arm"

inherit systemd

# Find libbsd headers during native builds
CC:append:class-native = " -I${STAGING_INCDIR}"
CC:append:class-nativesdk = " -I${STAGING_INCDIR}"

CORE_LIBS = "libbase liblog libcutils libbacktrace libutils"
ALL_LIBS = "libunwind ${CORE_LIBS}"

#apply all the patches maintained in the debian version.
do_unpack_and_patch_debian() {
    cd ${S}/system/core
    for i in `find ${S}/system/core/debian/patches -name "*.patch"`; do
        patch -p1 < $i
    done
    #a patch with no .patch extention, lets apply that
    patch -p1 < ${S}/system/core/debian/patches/Added-missing-headers
    cd ${S}/external/libunwind
    for i in `find ${S}/external/libunwind/debian/patches -name "*.patch"`; do
        patch -p1 < $i
    done
}
addtask unpack_and_patch_debian after do_unpack before do_patch

do_compile() {
    case "${HOST_ARCH}" in
      arm)
        export android_arch=linux-arm
        cpu=arm
        deb_host_arch=arm
      ;;
      aarch64)
        export android_arch=linux-arm64
        cpu=arm64
        deb_host_arch=arm64
      ;;
      riscv64)
        export android_arch=linux-riscv64
      ;;
      mips|mipsel)
        export android_arch=linux-mips
        cpu=mips
        deb_host_arch=mips
      ;;
      mips64|mips64el)
        export android_arch=linux-mips64
        cpu=mips64
        deb_host_arch=mips64
      ;;
      powerpc|powerpc64)
        export android_arch=linux-ppc
      ;;
      i586|i686|x86_64)
        export android_arch=linux-x86
        cpu=x86_64
        deb_host_arch=amd64
      ;;
    esac

    export SRCDIR=${S}

    oe_runmake -f ${S}/external/libunwind/debian/libunwind.mk -C ${S}/external/libunwind CPU=${cpu}

    for lib in ${CORE_LIBS}; do
      oe_runmake -f ${S}/system/core/debian/${lib}.mk -C ${S}/system/core
    done
}

do_install() {
    install -d ${D}${includedir}/android/
    cp -rf ${S}/debian/out/usr/include/* ${D}${includedir}/android/

    install -d  ${D}${libdir}/android
    install -m 0755 ${S}/debian/out/usr/lib/android/*.so.0 ${D}${libdir}/android/
    cd ${D}${libdir}/android
    for lib in ${ALL_LIBS}; do
        ln -s ${lib}.so.0 ${lib}.so
    done
}

FILES:${PN} += "${libdir}/android/*.so.0 ${includedir}/android/*"
FILES:${PN}-dev += "${libdir}/android/*.so"
