PREFIX = /usr

all: check

check: check-same-icon
	gtk-update-icon-cache deepin || exit 101
	gtk-update-icon-cache Sea || exit 101
	-rm -f deepin/icon-theme.cache
	-rm -f Sea/icon-theme.cache

check-name-unique:
	find deepin -name "*.svg" | xargs -n1 basename | sort | uniq -d | xargs -I '{}' find -name '{}'
check-same-icon:
	find deepin -type f | xargs md5sum | sort | uniq --check-chars=32 -d

prepare: check-name-unique check-same-icon
	mkdir -p build

build: prepare convert

convert:
	mkdir -p build
	python tools/convert.py deepin build

clean:
	rm -rf build

install: install-icons install-cursors hicolor-links
	@echo "Fix icon files permission"
	find $(DESTDIR)${PREFIX}/share/icons -type f -exec chmod 644 {} \;

install-icons:
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/deepin
	cp -r deepin/* $(DESTDIR)$(PREFIX)/share/icons/deepin
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/Sea
	cp -r Sea/* $(DESTDIR)$(PREFIX)/share/icons/Sea

install-cursors:
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/deepin
	cp -r deepin/cursors $(DESTDIR)$(PREFIX)/share/icons/deepin
	install -m644 deepin/cursor.theme $(DESTDIR)$(PREFIX)/share/icons/deepin/cursor.theme

hicolor-links:
	./tools/hicolor.links deepin hicolor.list $(DESTDIR)
