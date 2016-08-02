export THEOS_DEVICE_IP = 192.168.0.4
#export THEOS_DEVICE_PORT = 2222
export SDKVERSION = 6.1
export ARCHS = armv7 arm64
export TARGET = iphone:9.3:4.3

include ../theos/makefiles/common.mk
TWEAK_NAME = RemoveRecents
RemoveRecents_FILES = Tweak.xm
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
