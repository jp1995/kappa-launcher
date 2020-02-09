
DEST ?= /usr/bin

all:
	@echo Run \'make install\' to install Kappa Launcher on your device.

install:
	@cp kpl $(DEST)/kpl
	@chmod 755 $(DEST)/kpl
	@echo Kappa Launcher has been installed on your device. The binary executable is kpl.

uninstall:
	@rm -rf $(DEST)/kpl
	@echo Kappa Launcher has been removed from your device.
