AWK=gawk
TROFF=groff
TROFF_OPTS=-Kutf8 -Tpdf -dpaper=a4 -P-pa4 -ms -mspdf -pdfmark -spt

.PHONY: all clean
all: demo.pdf

%.pdf: %.ms
	cat $< | ${TROFF} ${TROFF_OPTS} | ./toc-rel.sh > $@

clean:
	rm *.pdf
