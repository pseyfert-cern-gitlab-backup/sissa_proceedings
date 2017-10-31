Title: hacking biblatex for PoS (SISSA's Proceedings fo Science)
Date: 2016-11-05 14:36
Category: Computer
Tags: computing, physics-software
Authors: Paul Seyfert
Summary: I wasn't satisfied with how citations were handled in my ICHEP proceedings.

# starting point

The PoS template comes without predefined bibtex styles. This is actually quite
good as one doesn't need to fight against incompatible configurations,
mandatory fields, non-implemented document classes, translating from bibtex to
latex or biblates. So I started with

```tex
\documentclass{PoS}
% other things
\usepackage[hyperref=true,backend=biber,sorting=none,firstinits=true]{biblatex}
\addbibresource{main.bib}
% other things
\begin{document}
\input{content}
\printbibliography
\end{document}
```

Some explanations

 * `sorting=none` I here want numbers as citations keys and them appearing in order of citation [link](http://tex.stackexchange.com/questions/51434/biblatex-citation-order/51439#51439)
 * `hyperref=true` Biblatex should produce clickable links (unfortunately this has no effect)
 * `backend=biber` use biber instead of bibtex for generating the citations. That's nowadays recommended on stackexchange but I didn't dive into the details.
 * `firstinits=true` some citation exports provide spelled out first names of authors, some don't. Not write the first names of all people by hand, I want consistently abbreviated first names, regardless of what's in the .bib file [link 1](http://tex.stackexchange.com/a/227401/95440) [link 2](http://tex.stackexchange.com/questions/21974/biblatex-abbreviated-author-names)

# hyperref in PoS

One cannot just load

```tex
\documentclass{PoS}
\usepackage{hyperref}
```

this leads to errors of undefined commands. Must be related how hyperlinks are
already defined in `PoS`. I didn't dive down but accepted instead that I won't
load `hyperref`. Some necessary changes arise:

 * `biblatex` detects that `hyperref` is not loaded and doesn't create clickable links for arxiv references or DOI.
 * `texorpdfstring` is undefined.

For the latter I did
```tex
\newcommand{\texorpdfstring}[2]{#1}
```
means the whole functionality is lost, but I don't have to modify prewritten text.
For the former I looked up in biblatex.def how doi and eprints are handled and removed the switch for detecting hyperref (NB: `href` is defined by PoS)
```tex
\usepackage[hyperref=true,backend=biber,sorting=none,firstinits=true]{biblatex}
\makeatletter
\DeclareFieldFormat{doi}{%
  \mkbibacro{DOI}\addcolon\space%
    {\href{http://dx.doi.org/#1}{\nolinkurl{#1}}}}
\DeclareFieldFormat{eprint:arxiv}{%
  arXiv\addcolon\space%
    {\href{http://arxiv.org/\abx@arxivpath/#1}{%
       \nolinkurl{#1}%
       \iffieldundef{eprintclass}
         {}
         {\addspace\texttt{\mkbibbrackets{\thefield{eprintclass}}}}}}
    }
\makeatother
```

# unpublished articles

Naturally, only articles in journals can be cited in most citation systems, and
arxiv-only articles look terrible as one gets a lonely "In: " where the journal
name should appear.
[This can be modified with](http://tex.stackexchange.com/questions/10682/suppress-in-biblatex)

```tex
\renewbibmacro{in:}{}
```

# collaborations

How to handle collaborations is explained e.g.
[here](http://tex.stackexchange.com/questions/94877/display-collaboration-with-biblatex?noredirect=1&lq=1).
The recommendation for handling collaborations in biblatex appears to be the
`authortype` field. But I don't want to replace `collaboration` by `authortype`
every time I import citations. Hence, I searched a bit further and summarised
[here](http://tex.stackexchange.com/questions/333279/use-collaboration-field-with-biblatex-and-biber/333280#333280)
how I'm adding collaboration names to citations (especially before the first
author's name).

```tex
\DeclareSourcemap{
 \maps[datatype=bibtex,overwrite=true]{
  \map{
    \step[fieldsource=Collaboration, final=true]
    \step[fieldset=usera, origfieldval, final=true]
  }
 }
}

\renewbibmacro*{author}{%
  \iffieldundef{usera}{%
    \printnames{author}%
  }{%
    \printfield{usera}, \printnames{author}%
  }%
}%
```

With these settings I have:
 * names consistently spelled with abbreviated first names
 * collaboration names before the author names
 * nice display for articles with and without journal
 * printed DOI and arxiv fields with clickable links
 * all that for citations as they come from inspire (non-standard 'collaboration' field)
 * clickable URL

# summary

```latex
\documentclass{PoS}
% other things
\newcommand{\texorpdfstring}[2]{#1}
\usepackage[hyperref=true,backend=biber,sorting=none,firstinits=true]{biblatex}
\addbibresource{main.bib}
\makeatletter
\DeclareFieldFormat{url}{%
  \mkbibacro{URL}\addcolon\space%
    {\href{#1}{\nolinkurl{#1}}}}
\DeclareFieldFormat{doi}{%
  \mkbibacro{DOI}\addcolon\space%
    {\href{http://dx.doi.org/#1}{\nolinkurl{#1}}}}
\DeclareFieldFormat{eprint:arxiv}{%
  arXiv\addcolon\space%
    {\href{http://arxiv.org/\abx@arxivpath/#1}{%
       \nolinkurl{#1}%
       \iffieldundef{eprintclass}
         {}
         {\addspace\texttt{\mkbibbrackets{\thefield{eprintclass}}}}}}
    }
\makeatother
\renewbibmacro{in:}{}
\DeclareSourcemap{
 \maps[datatype=bibtex,overwrite=true]{
  \map{
    \step[fieldsource=Collaboration, final=true]
    \step[fieldset=usera, origfieldval, final=true]
  }
 }
}

\renewbibmacro*{author}{%
  \iffieldundef{usera}{%
    \printnames{author}%
  }{%
    \printfield{usera}, \printnames{author}%
  }%
}%
% other things
\begin{document}
\input{content}
\printbibliography
\end{document}
```
