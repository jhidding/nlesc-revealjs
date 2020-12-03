#| Makefile
#| ========
#|
#| Write your presentation in Markdown. This `Makefile` lets you watch the sources
#| and preview the presentation, live in your browser.
#|
#| Usage
#| -----
#|
#|     make [help|clean|watch|pages]
#|
#| Prerequisites
#| -------------
#|
#| * Pandoc
#| * Node (stable)
#| * Reveal.js (to serve locally, `make reveal.js`)
#| * inotify-tools
#|

revealjs_url = .
theme = nlesc
source = README.md

pandoc_args := -s -t revealjs
pandoc_args += -V revealjs-url=https://revealjs.com
pandoc_args += --css nlesc.css

#|
#| Targets
#| -------

#| * `help`: print this help
help:
	@ grep -e '^#|' Makefile \
	| sed -e 's/^#| \?\(.*\)/\1/' \
	| pandoc -f markdown -t scripts/terminal.lua \
	| fold -s -w 80

#| * `watch`: reload browser upon changes
watch: reveal.js/index.html reveal.js/dist/theme/nlesc.css reveal.js/img
	@tmux new-session make --no-print-directory watch-pandoc \; \
		split-window -v make --no-print-directory watch-reveal \; \
		select-layout even-vertical \;

watch-pandoc:
	@while true; do \
		inotifywait -e close_write $(source) Makefile theme/*; \
		make reveal.js/index.html reveal.js/dist/theme/source/nlesc.scss reveal.js/img; \
	done

watch-reveal:
	@cd reveal.js && npm start

#| * `clean`: clean reveal.js and docs
clean:
	rm -rf reveal.js docs

#| * `pages`: create documentation for github.io pages
pages: docs docs/img docs/index.html docs/nlesc.css docs/dist

# Rules ============================================

reveal.js/index.html: $(source) | reveal.js
	pandoc -t revealjs -s -o ./reveal.js/index.html \
		$(source) --mathjax \
		-V revealjs-url=$(revealjs_url) \
		-V theme=$(theme)

reveal.js/img: | reveal.js img
	cd reveal.js && ln -s ../img .

reveal.js/css/theme/source/nlesc.scss: theme/nlesc.scss | reveal.js
	cp theme/nlesc.scss reveal.js/css/theme/source

reveal.js/dist/theme/nlesc.css: reveal.js/css/theme/source/nlesc.scss
	cd reveal.js && npm run build -- css-themes

reveal.js:
	if [ -d "reveal.js" ]; then \
		cd reveal.js && git pull origin master; \
	else \
		git clone https://github.com/hakimel/reveal.js.git; \
	fi
	cd reveal.js && npm install && npm audit fix

docs:
	mkdir -p docs
	touch docs/.nojekyll

docs/img: img | docs
	cp -r img docs

docs/dist: reveal.js/dist | docs
	cp -r $< $@

docs/nlesc.css: reveal.js/dist/theme/nlesc.css | docs
	cp reveal.js/dist/theme/nlesc.css docs

docs/index.html: $(source) Makefile | docs
	pandoc -t revealjs -s -o ./docs/index.html \
		$(source) --mathjax \
		-V revealjs-url=./dist \
		--css nlesc.css

.PHONY: all clean watch pages watch-pandoc watch-reveal

