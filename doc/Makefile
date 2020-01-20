.PHONY: all
all: man-terranix_description.refsection.xml man-terranix_functions.refsection.xml man-terranix_hcl.refsection.xml man-terranix_modules.refsection.xml man-terranix_options.refsection.xml man-terranix_conditions.refsection.xml


%.refsection.xml: %.refsection.md
	pandoc $^ -w docbook+smart \
		-f markdown+smart \
	  | sed -e 's|<ulink url=|<link xlink:href=|' \
	      -e 's|</ulink>|</link>|' \
	      -e 's|<sect. id=|<section xml:id=|' \
	      -e 's|</sect[0-9]>|</section>|' \
	      -e '1s| id=| xml:id=|' \
	      -e '1s|\(<[^ ]* \)|\1xmlns="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink" |' \
	      -e 's|<section|<refsection|' \
	      -e 's|</section>|</refsection>|' \
	| cat  > $@

%.section.xml: %.section.md
	pandoc $^ -w docbook+smart \
		-f markdown+smart \
	  | sed -e 's|<ulink url=|<link xlink:href=|' \
	      -e 's|</ulink>|</link>|' \
	      -e 's|<sect. id=|<section xml:id=|' \
	      -e 's|</sect[0-9]>|</section>|' \
	      -e '1s| id=| xml:id=|' \
	      -e '1s|\(<[^ ]* \)|\1xmlns="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink" |' \
	| cat  > $@

%.chapter.xml: %.chapter.md
	pandoc $^ -w docbook+smart \
		--top-level-division=chapter \
		-f markdown+smart \
	  | sed -e 's|<ulink url=|<link xlink:href=|' \
	      -e 's|</ulink>|</link>|' \
	      -e 's|<sect. id=|<section xml:id=|' \
	      -e 's|</sect[0-9]>|</section>|' \
	      -e '1s| id=| xml:id=|' \
	      -e '1s|\(<[^ ]* \)|\1|' \
	| cat  > $@
