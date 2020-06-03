THEOS_DEVICE_IP = 192.168.1.210

include $(THEOS)/makefiles/common.mk
TWEAK_NAME = RemoveRecents
$(TWEAK_NAME)_FILES = Tweak.xm
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
