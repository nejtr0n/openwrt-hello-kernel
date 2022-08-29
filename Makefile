include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=hello-kernel
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define KernelPackage/hello-kernel
  SUBMENU:=Other modules
  TITLE:=Hellowrld kernel driver
  FILES:=$(PKG_BUILD_DIR)/hello-kernel.ko
  AUTOLOAD:=$(call AutoProbe,81,hello-kernel)
  KCONFIG:=
endef

define KernelPackage/hello-kernel/description
  Kernel helloworld
endef

EXTRA_CFLAGS:= \
	$(patsubst CONFIG_%, -DCONFIG_%=1, $(patsubst %=m,%,$(filter %=m,$(EXTRA_KCONFIG)))) \
	$(patsubst CONFIG_%, -DCONFIG_%=1, $(patsubst %=y,%,$(filter %=y,$(EXTRA_KCONFIG)))) \

MAKE_OPTS := \
	$(KERNEL_MAKE_FLAGS) \
	M="$(PKG_BUILD_DIR)"

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		$(MAKE_OPTS) CONFIG_HELLO-KERNEL=m \
		modules
endef

$(eval $(call KernelPackage,hello-kernel))
