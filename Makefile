PREFIX = /usr

all: build

build:
	mkdir -p build
	python tools/convert.py deepin build
	python tools/convert.py deepin-2014 build

clean:
	rm -rf build

install:
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons
	cp -r build/deepin $(DESTDIR)$(PREFIX)/share/icons/Deepin
	cp -r build/deepin-2014 $(DESTDIR)$(PREFIX)/share/icons/Deepin-2014
