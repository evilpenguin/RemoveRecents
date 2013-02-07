export THEOS_DEVICE_IP = localhost
export THEOS_DEVICE_PORT = 2222
export SDKVERSION = 6.1
export ARCHS=armv7 armv6
export TARGET=iphone:latest:4.3

include theos/makefiles/common.mk
TWEAK_NAME = RemoveRecents
RemoveRecents_FILES = Tweak.xm
include $(THEOS_MAKE_PATH)/tweak.mk
