#
# Mainly via .github/workflows/vpinball.yml
#
PLATFORM = win-x86
CONFIG   = Debug
DIST_DIR = dist
INSTALL_DIR = /mnt/c/Visual\ Pinball

# Auto-computed variables
PLT      = Win32
VPX_EXE  = VPinballX.exe
ifeq ($(PLATFORM),win-x64)
	PLT     = x64
	VPX_EXE = VPinballX64.exe
endif

export DXSDK_DIR  = DXSDK
export WSLENV    := $(WSLENV):DXSDK_DIR/w

default: build

clean:
	rm -rf build/* || true

.PHONY: build
build:
	cp cmake/CMakeLists_$(PLATFORM).txt CMakeLists.txt
	cmake.exe -G "Visual Studio 16 2019" -A $(PLT) -B build
	cmake.exe --build build --config $(CONFIG)

package:
	mkdir -p $(DIST_DIR)
	cp build/$(CONFIG)/$(VPX_EXE) $(DIST_DIR)
	cp build/$(CONFIG)/*.dll $(DIST_DIR)
	cp -r build/$(CONFIG)/scripts $(DIST_DIR)
	cp -r build/$(CONFIG)/tables $(DIST_DIR)
	cp -r build/$(CONFIG)/docs $(DIST_DIR)

install:
	rsync -a $(DIST_DIR)/ $(INSTALL_DIR)

#
# Pretend/broken targets (really just my notes)
#
bootstrap:
	# curl -sL https://download.microsoft.com/download/a/e/7/ae743f1f-632b-4809-87a9-aa1bb3458e31/DXSDK_Jun10.exe -o DXSDK_Jun10.exe
	# 7z x DXSDK_Jun10.exe DXSDK/Include -otmp
	# 7z x DXSDK_Jun10.exe DXSDK/Lib -otmp
	# mv tmp/DXSDK DXSDK
	# rm -fR DXSDK_Jun10.exe tmp
	# ls -Ra DXSDK

	# # cmake can't find fxc.exe so copy one into the a directory in the path
	# cp "/c/Program Files (x86)/Windows Kits/10/bin/10.0.19041.0/x86/fxc.exe" /mingw64/bin

build_with_bat:
	./win_build.bat CFG:DEBUG PLA:WIN32 GEN:10 PRJ:VPINBALL

help_build_with_bat:
	@echo Make sure youve run...
	@echo "    sudo sh -c 'echo :WindowsBatch:E::bat::/init: > /proc/sys/fs/binfmt_misc/register'"
	@echo "    chmod +x $(MAME_SRC)/win_build.bat"
	@echo ...or else this wont work
