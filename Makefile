# ╭─────╮  Houston:
# │ ◠ ◡ ◠  Good luck out there, astronaut! 🚀
# ╰─────╯

PREFIX ?= /usr/local
OPTDIR ?= /opt

BINDIR = $(PREFIX)/bin
DATDIR = $(OPTDIR)/astroproject
# all: build install

# sudo make install
install:
	mkdir -p $(DATDIR)

	cp ./astroproject $(BINDIR)/astroproject
	cp ./astroproject.sh $(DATDIR)/astroproject.sh

	chmod +x $(BINDIR)/astroproject
	chmod +x $(DATDIR)/astroproject.sh

	echo "Done"

# sudo make uninstall
uninstall:
	rm $(BINDIR)/astroproject
	rm -rf $(DATDIR)