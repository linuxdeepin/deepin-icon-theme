PREFIX = /usr

all: build

check-name-unique:
	find deepin -name "*.svg" | xargs -n1 basename | sort | uniq -d | xargs -I '{}' find -name '{}'
check-same-icon:
	find deepin -type f | xargs md5sum | sort | uniq --check-chars=32 -d

prepare: check-name-unique check-same-icon
	mkdir -p build

build: prepare convert debian/links

convert:
	mkdir -p build
	python2 tools/convert.py deepin build

clean:
	rm -rf build

install: install-icons install-cursors install-override

install-icons:
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/deepin
	cp -r build/deepin/* $(DESTDIR)$(PREFIX)/share/icons/deepin

install-cursors:
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/deepin
	cp -r deepin/cursors $(DESTDIR)$(PREFIX)/share/icons/deepin
	install -m644 deepin/cursor.theme $(DESTDIR)$(PREFIX)/share/icons/deepin/cursor.theme

install-override:
	cp -r override/* $(DESTDIR)$(PREFIX)/share/icons/deepin

debian/links: hicolor.list
	sh tools/hicolor.links build/deepin hicolor.list > $@
