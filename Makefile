PREFIX = /usr

all: build

check-name-unique:
	find deepin -name "*.svg" | xargs -n1 basename | sort | uniq -d | xargs -I '{}' find -name '{}' 
	find deepin-2014 -name "*.svg" | xargs -n1 basename | sort | uniq -d | xargs -I '{}' find -name '{}'
check-same-icon:
	find deepin -type f | xargs md5sum | sort | uniq --check-chars=32 -d 
	find deepin-2014 -type f | xargs md5sum | sort | uniq --check-chars=32 -d

build:
	mkdir -p build
	python tools/convert.py deepin build
	python tools/convert.py deepin-2014 build

clean:
	rm -rf build

install: install-icons install-cursors

install-icons:
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons
	cp -r build/deepin $(DESTDIR)$(PREFIX)/share/icons/Deepin
	cp -r build/deepin-2014 $(DESTDIR)$(PREFIX)/share/icons/Deepin-2014

install-cursors:
	cp -r deepin/cursors $(DESTDIR)$(PREFIX)/share/icons/Deepin
	install -m644 deepin/cursor.theme $(DESTDIR)$(PREFIX)/share/icons/Deepin/cursor.theme

debian/links: build hicolor.list
	sh tools/hicolor.links build/deepin hicolor.list > $@
