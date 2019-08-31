PREFIX = /usr

all: check cursor

cursor:
	cd cursors-src/loginspinner/ && make

check: check-same-icon check-perm
	gtk-update-icon-cache deepin || exit 101
	gtk-update-icon-cache deepin-dark || exit 101
	-rm -f deepin/icon-theme.cache
	-rm -f deepin-dark/icon-theme.cache

check-name-unique:
	find deepin -name "*.svg" | xargs -n1 basename | sort | uniq -d | xargs -I '{}' find -name '{}'
	find deepin-dark -name "*.svg" | xargs -n1 basename | sort | uniq -d | xargs -I '{}' find -name '{}'
check-same-icon:
	find deepin -type f | xargs md5sum | sort | uniq --check-chars=32 -d
	find deepin-dark -type f | xargs md5sum | sort | uniq --check-chars=32 -d

check-perm: hicolor-links
	@echo "Fix icon files permission"
	find deepin -type f -exec chmod 644 {} \;
	find deepin-dark -type f -exec chmod 644 {} \;

prepare: check-name-unique check-same-icon
	mkdir -p build

build: prepare convert

convert:
	mkdir -p build
	python tools/convert.py deepin build

clean:
	rm -rf build


install-icons:
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/deepin
	cp -r deepin/* $(DESTDIR)$(PREFIX)/share/icons/deepin
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/deepin-dark
	cp -r deepin-dark/* $(DESTDIR)$(PREFIX)/share/icons/deepin-dark
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/deepin-v20
	cp -r deepin-v20/* $(DESTDIR)$(PREFIX)/share/icons/deepin-v20

install-cursors:
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/deepin
	cp -r deepin/cursors $(DESTDIR)$(PREFIX)/share/icons/deepin
	install -m644 deepin/cursor.theme $(DESTDIR)$(PREFIX)/share/icons/deepin/cursor.theme

hicolor-links:
	./tools/hicolor.links deepin hicolor.list ./
