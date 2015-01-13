PREFIX = /usr

all: build

check-name-unique: 
	find deepin -name "*.svg" | xargs -n1 basename | sort | uniq -d | xargs -I '{}' find -name '{}' 
	find deepin-2014 -name "*.svg" | xargs -n1 basename | sort | uniq -d | xargs -I '{}' find -name '{}'

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

debian/links: build hicolor.list
	sh tools/hicolor.links build/deepin hicolor.list > $@
