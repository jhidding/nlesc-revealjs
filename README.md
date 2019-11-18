---
title: Quick presentation with Reveal.js and Pandoc
author: Johan Hidding
---

# Reveal.js with NLeSC theme

## What is this?

* A template for creating slides with NLeSC look. It uses `pandoc` to produce `reveal.js` slides.
* Clone this repository at: [github.com/jhidding/nlesc-revealjs](https://github.com/jhidding/nlesc-revealjs)

## Prerequisites

* make
* inotifytools
* git
* Pandoc
* for the NLeSC theme: Akkurat fonts (available on NLeSC SharePoint)

## Working on your presentation

* First time, running `make` should clone `reveal.js` for you.
* Run `npm start` from the `reveal.js` directory to serve your presentation.
* Run `make watch` script to automatically update while editing.
* Build themes: `npm run build -- css-themes`

## While presenting

* press `s` to show speaker notes
    - This only works if you present using `npm start`

::: {.notes}
This is a note right here!
:::

## Publish on Github.io

* Create a static page with `make pages`
* Enable `github.io` pages:
    - Go to Github project settings
    - Section "GitHub Pages"
    - set "Source" to "master branch '/docs' folder"

## Learn more

* Study the `Makefile`
* Create a PDF using [DeckTape](https://github.com/astefanutti/decktape)
* [Pandoc manual](https://pandoc.org/MANUAL.html)
* [Reveal.js README](https://github.com/hakimel/reveal.js/blob/master/README.md)

