PREFIX = /usr

all: check  cursors-bloom  cursors-bloom-dark cursors-bloom-fantacy

cursors-bloom:
	cd cursors-src/bloom/loginspinner/ && make

cursors-bloom-dark:
	cd cursors-src/bloom-dark/loginspinner/ && make

cursors-bloom-fantacy:
	cd cursors-src/bloom-fantacy/loginspinner/ && make

check: check-same-icon check-perm
	gtk-update-icon-cache bloom || exit 101
	gtk-update-icon-cache bloom-dark || exit 101
	-rm -f bloom/icon-theme.cache
	-rm -f bloom-dark/icon-theme.cache

check-name-unique:
	find bloom -name "*.svg" | xargs -n1 basename | sort | uniq -d | xargs -I '{}' find -name '{}'
	find bloom-dark -name "*.svg" | xargs -n1 basename | sort | uniq -d | xargs -I '{}' find -name '{}'
check-same-icon:
	find bloom -type f | xargs md5sum | sort | uniq --check-chars=32 -d
	find bloom-dark -type f | xargs md5sum | sort | uniq --check-chars=32 -d

check-perm: hicolor-links
	@echo "Fix icon files permission"
	find bloom -type f -exec chmod 644 {} \;
	find bloom-dark -type f -exec chmod 644 {} \;

prepare: check-name-unique check-same-icon
	mkdir -p build

build: prepare convert

convert:
	mkdir -p build
	python tools/convert.py bloom build

clean:
	rm -rf build


install-icons:
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/bloom
	cp -r bloom/* $(DESTDIR)$(PREFIX)/share/icons/bloom
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/bloom-dark
	cp -r bloom-dark/* $(DESTDIR)$(PREFIX)/share/icons/bloom-dark
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/Vintage
	cp -r Vintage/* $(DESTDIR)$(PREFIX)/share/icons/Vintage

install-cursors:
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/bloom
	cp -r bloom/cursors $(DESTDIR)$(PREFIX)/share/icons/bloom
	install -m644 bloom/cursor.theme $(DESTDIR)$(PREFIX)/share/icons/bloom/cursor.theme

hicolor-links:
	./tools/hicolor.links bloom hicolor.list ./
