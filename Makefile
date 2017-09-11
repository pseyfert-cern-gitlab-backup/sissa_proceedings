all: clean
	pdflatex final.tex
	biber final
	pdflatex final.tex
	pdflatex final.tex
	pdflatex withlines.tex
	biber withlines
	pdflatex withlines.tex
	pdflatex withlines.tex
	mv withlines.pdf final_with_linenumbers.pdf

quick:
	biber final
	pdflatex final.tex

clean:
	rm -f final.aux final.bbl final.blg final.log final.out final.pdf final.spl final.bcf final.run.xml
	rm -f withlines.aux withlines.bbl withlines.blg withlines.log withlines.out withlines.pdf withlines.spl withlines.bcf withlines.run.xml

include aspell.mk
