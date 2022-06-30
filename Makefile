ARCHS = arm64 arm64e
THEOS_DEVICE_IP = 192.168.0.253
INSTALL_TARGET_PROCESSES = SpringBoard
TARGET = iphone:clang:14.4:13
PACKAGE_VERSION = 2.0.1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DockLS

DockLS_PRIVATE_FRAMEWORKS = SpringBoardHome SpringBoard SpringBoardFoundation FrontBoard MaterialKit
DockLS_FILES = $(shell find Sources/DockLS -name '*.swift') $(shell find Sources/DockLSC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
DockLS_SWIFTFLAGS = -ISources/DockLSC/include
DockLS_CFLAGS = -fobjc-arc -ISources/DockLSC/include

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += dockls
include $(THEOS_MAKE_PATH)/aggregate.mk
