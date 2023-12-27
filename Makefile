# ╭─────╮  Houston:
# │ ◠ ◡ ◠  Good luck out there, astronaut! 🚀
# ╰─────╯

PREFIX ?= /usr/local
OPTDIR ?= /opt

BINDIR = $(PREFIX)/bin
DATDIR = $(OPTDIR)/mkastro
BIN = mkastro

# all: build install

# sudo make install
install:
	mkdir -p $(DATDIR)

	cp ./$(BIN) $(BINDIR)/$(BIN)
	cp ./$(BIN).sh $(DATDIR)/$(BIN).sh

	chmod +x $(BINDIR)/$(BIN)
	chmod +x $(DATDIR)/$(BIN).sh

	echo "Done"

# sudo make uninstall
uninstall:
	rm $(BINDIR)/$(BIN)
	rm -rf $(DATDIR)