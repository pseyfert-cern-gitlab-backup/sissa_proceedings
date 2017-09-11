# sissa proceedings

Following a blog post of mine, I put my additions to the SISSA proceedings into
a bare repository.  I do not ship the files from SISSA, as you're supposed to
get a fresh file from them. The files I deleted are:

 * PoSlogo.pdf
 * PoSlogo.ps
 * PoStemplate.odt
 * PoS.cls
 * PoSauthmanual.pdf

Just re-add them to the directory.

## Files to work on

Conference name, authors' names and abstract go to `header.tex`. Any textual
content goes to `content.tex` (of cause you can include other tex files in
there. The files `final.tex`, `preamble.tex`, and `withlines.tex` are meant
not to be changed.

## spellcheck

The spell check can be run interactively
```
make interactive-spellcheck
make content.interactive-spellcheck
make <filename>.interactive-spellcheck
```

or in batch mode (just produce a text file with all spelling mistakes. This
runs in the gitlab CI. The framework files (`final.tex`, `preamble.tex`, and
`withlines.tex` are excluded).

## build targets

By default two pdfs get created. A `final.pdf` as the proceedings should look
and a `withlines.pdf` which has line numbers (for a review). These are created with
```
make
```

There is also the special target `make quick` which is a minimalistic rerun of
`final.pdf` for quick debugging (no cleanup from previous run, possibly not
getting reference updates right). Also, `make clean` should remove all left
over files from the build process and is called in every normal build
automatically to get rid of left-over files from a previous run and make runs
independent of each other.
