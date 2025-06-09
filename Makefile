# A custom makefile for the dita-phrases utiliy
# Copyright (C) 2025 Jaromir Hradilek

# MIT License
#
# Permission  is hereby granted,  free of charge,  to any person  obtaining
# a copy of  this software  and associated documentation files  (the "Soft-
# ware"),  to deal in the Software  without restriction,  including without
# limitation the rights to use,  copy, modify, merge,  publish, distribute,
# sublicense, and/or sell copies of the Software,  and to permit persons to
# whom the Software is furnished to do so,  subject to the following condi-
# tions:
# # The above copyright notice  and this permission notice  shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS",  WITHOUT WARRANTY OF ANY KIND,  EXPRESS
# OR IMPLIED,  INCLUDING BUT NOT LIMITED TO  THE WARRANTIES OF MERCHANTABI-
# LITY,  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT
# SHALL THE AUTHORS OR COPYRIGHT HOLDERS  BE LIABLE FOR ANY CLAIM,  DAMAGES
# OR OTHER LIABILITY,  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM,  OUT OF OR IN CONNECTION WITH  THE SOFTWARE  OR  THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

# General settings:
NAME     = dita-phrases
VERSION  = 0.1.0
SHELL    = /bin/sh
INSTALL  = /usr/bin/install -c

# Source files:
SRCS     = dita-phrases.rb
DOCS     = AUTHORS LICENSE README.md TODO

# Installation directories:
prefix   = /usr/local
bindir   = $(prefix)/bin
docdir   = $(prefix)/share/doc/$(NAME)-$(VERSION)

# Install the utility:
.PHONY: install
install: $(SRCS) $(DOCS)
	@echo "Creating target directories:"
	$(INSTALL) -d $(bindir)
	$(INSTALL) -d $(docdir)
	@echo "Installing executable scripts:"
	$(INSTALL) -m 755 dita-phrases.rb $(bindir)/dita-phrases
	@echo "Installing documentation files:"
	$(INSTALL) -m 644 AUTHORS $(docdir)
	$(INSTALL) -m 644 LICENSE $(docdir)
	$(INSTALL) -m 644 README.md $(docdir)
	$(INSTALL) -m 644 TODO $(docdir)
	@echo "Done."

# Uninstall the utiliy:
.PHONY: uninstall
uninstall:
	@echo "Removing executable scripts:"
	-rm -f $(bindir)/dita-phrases
	@echo "Removing documentation files:"
	-rm -f $(docdir)/AUTHORS
	-rm -f $(docdir)/LICENSE
	-rm -f $(docdir)/README.md
	-rm -f $(docdir)/TODO
	@echo "Removing empty directories:"
	-rmdir $(bindir)
	-rmdir $(docdir)
	@echo "Done."
