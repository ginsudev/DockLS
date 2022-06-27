ARCHS = arm64 arm64e
TARGET = iphone:clang:14.4:14

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = dockls

dockls_LIBRARIES = gscommon
dockls_FILES = $(shell find Sources/dockls -name '*.swift') $(shell find Sources/docklsC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
dockls_INSTALL_PATH = /Library/PreferenceBundles
dockls_SWIFTFLAGS = -ISources/docklsC/include
dockls_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
