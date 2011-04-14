ANSYS_MAJOR := 13
ANSYS_MINOR := 0

HOSTNAME := $(shell hostname)
DIR := $(shell pwd)

# use make in the "tags" release directories
#RELEASE := $(shell $$($(DIR)))

ifeq ($(HOSTNAME),urmel)
 EMACS_DIR := /usr/local/src
else
 EMACS_DIR := ~
endif

EMACS_VERSION := emacs-23.2
EMACS_PACKAGE := $(EMACS_VERSION)-bin-i386.zip
EMACS_SOURCE_PACKAGE := $(EMACS_VERSION).tar.bz2
EMACS_SOURCE_PACKAGE_SIG := $(EMACS_VERSION).tar.bz2.sig
ADDRESS := http://ftp.gnu.org/pub/gnu/emacs/$(EMACS_PACKAGE)
SOURCE_ADDRESS := http://ftp.gnu.org/pub/gnu/emacs/$(EMACS_SOURCE_PACKAGE)
SIG_ADDRESS := http://ftp.gnu.org/pub/gnu/emacs/$(EMACS_SOURCE_PACKAGE_SIG)
# ftp://ftp.informatik.rwth-aachen.de/pub/gnu/
EMACS_EXE := $(EMACS_DIR)/$(EMACS_VERSION)/src/emacs

# this is the current ansys-mode version
MODE_VERSION := 1
VERSION := $(ANSYS_MAJOR).$(ANSYS_MINOR).$(MODE_VERSION)
PACKAGE := ansys-mode-$(VERSION).tgz

EL_FILES := ansys-mode.el ansys-keyword.el \
  ansys-template.el ansys-process.el

ELC_FILES := $(EL_FILES:.el=.elc)

FILES := LICENSE README TODO fontification.mac default_el

PACKAGE_FILES :=  $(FILES) $(EL_FILES)

$(PACKAGE) : $(PACKAGE_FILES) makefile
	@echo "Packaging $@ ..."
	@echo
	@tar -czvf $@ $(PACKAGE_FILES)
	@echo
	@echo "... $@ done."
	@echo "------------------------------"

# this is the Ansys mode package
.PHONEY : MODE
MODE : $(PACKAGE) TAGS

.PHONEY : ALL
ALL : MODE EMACS

.PHONEY : CLEAN
CLEAN :
	rm $(ELC_FILES)

# $(EMACS_SOURCE_PACKAGE_SIG) :
# 	cd $(EMACS_DIR); wget $(SIG_ADDRESS)

# $(EMACS_SOURCE_PACKAGE) : $(EMACS_SOURCE_PACKAGE_SIG)
# 	cd $(EMACS_DIR)
# 	wget $(SOURCE_ADDRESS)
# 	tar -xjvf $(EMACS_SOURCE_PACKAGE)

# $(EMACS_EXE) : $(EMACS_SOURCE_PACKAGE)
# 	cd $(EMACS_DIR)
# 	cd $(EMACS_VERSION)
# 	configure
# 	make

ansys-keyword.el : ansys-fontification.el ansys_dynprompt.txt ansys_elements.txt ansys_parametric_functions.txt ansys_get_functions.txt ansys_keywords.txt
	$(EMACS_EXE) --batch --load $<

%.elc : %.el
	$(EMACS_EXE) --batch -f batch-byte-compile $<

# default.el : default_el
# 	@cp default_el emacs-23.1/site-lisp/default.el

# This is Emacs for Windows packaged with Ansys mode
.PHONEY : EMACS
EMACS : $(EMACS_PACKAGE) $(PACKAGE)  $(ELC_FILES) default_el
	test -d $(EMACS_VERSION)/site-lisp || mkdir -p $(EMACS_VERSION)/site-lisp
	cp -uv $(FILES) $(EL_FILES) $(EMACS_VERSION)/site-lisp
	cp -uv $(ELC_FILES) $(EMACS_VERSION)/site-lisp
	cp -uv default_el $(EMACS_VERSION)/site-lisp/default.el
	cp -uv $(EMACS_PACKAGE) ansys-mode-$(VERSION)+$(EMACS_PACKAGE)
	zip -u ansys-mode-$(VERSION)+$(EMACS_PACKAGE) $(EMACS_VERSION)/site-lisp/*

$(EMACS_PACKAGE) :
		wget $(ADDRESS)

TAGS : makefile $(EL_FILES) default_el ansys-fontification.el
	etags $(EL_FILES) default_el ansys-fontification.el
