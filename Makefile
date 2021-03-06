
DEST ?= /usr/bin
DEST_CONFIG ?= /etc/kpl

all:
	@echo Run \'make install\' to install Kappa Launcher on your device.

install:
	@rm -rf $(DEST_CONFIG)
	@mkdir $(DEST_CONFIG)
	@cp kpl $(DEST)/kpl
	@cp config $(DEST_CONFIG)/config
	@chmod 755 $(DEST)/kpl
	@chmod 755 $(DEST_CONFIG)/config
	@echo Kappa Launcher has been installed on your device. The binary executable is kpl.

uninstall:
	@rm -rf $(DEST)/kpl
	@rm -rf $(DEST_CONFIG)/config
	@echo Kappa Launcher has been removed from your device.
