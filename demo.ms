.\" vim: ft=groff
.\" demo.ms
.\"
.\" A demonstration document using ms macros.
.\"
.\" -----------------------------------------------------------------------------------------------
.\" General document configuration
.\" -----------------------------------------------------------------------------------------------
.\" Assign some PDF information
.pdfinfo /Title Demo PDF: Demonstrating TOC Relocation
.pdfinfo /Author Blake Rain
.pdfinfo /Subject A demonstration of the relocation of the table of contents in a PDF.
.\" Change the size of headers that are level 4 and above, with the point size increasing by 1.5p.
.nr GROWPS 4
.nr PSINCR 1.5p
.\" Set the indentation and spacing for paragraphs and displays. Here PI and DI are the paragraph
.\" and display indentation, and PD is the paragraph distance/spacing.
.nr PI 0.25i
.nr DI 0.25i
.nr PD 0.5v
.\" Configure our page headers and footers: LH is left header, LF is left footer, and so on.
.ds LH \fBDemo PDF: Demonstrating TOC Relocation
.ds CH
.ds RH
.ds LF
.ds CF CC-BY-SA
.ds RF \\*[DY]
.\" -----------------------------------------------------------------------------------------------
.\" Set the document title (TL) and author information.
.\" -----------------------------------------------------------------------------------------------
.TL
Demo PDF: Demonstrating TOC Relocation
.AU
Blake Rain
.\" -----------------------------------------------------------------------------------------------
.\" Define a document abstract (between the AB and AE macros).
.\" -----------------------------------------------------------------------------------------------
.AB
This is the document abstract.
.AE
.\" -----------------------------------------------------------------------------------------------
.\" Document contents.
.\" -----------------------------------------------------------------------------------------------
.\" Set the left header to be name of the section.
.ds LH \fBIntroduction\fP
.\" Break onto a new page. We do this after setting the header, as a trap configured in the ms macro
.\" is what writes out the page header.
.bp
.\" Now set the left footer to be the page number. We leave this in place for the rest of the
.\" document until we get to the TOC output.
.ds LF \En[PN]
.\" Reset the page number back to one. This will ensure that the introduction is the first real page
.\" of the document. This will be reflected in the page numbering, and also in the TOC.
.nr % 1
.\" Start the numbered heading at level 1 and then render the heading, adding a TOC entry 'intro'.
.NH 1
.XN -N intro Introduction
.LP
This is the introduction to the document, and therefore needs to contain words that typically
describe the contents of the document. In this case, the document is a demonstration of how to
relocate the table of contents in a PDF document generated using the \fCtroff\fP typesetting tool.
.LP
Of course, we need a demonstration document into which our table of contents will be rendered
subsequent to being moved about by the extremely talented author. Well, maybe not so talented. After
all, he's having to use some dodgy shell and AWK scripts to lay out his PDFs properly!
.NH 2
.XN -N random-thoughts Random Thoughts
.LP
You know, I often find writing things like abstracts and introductions the hardest part of any
document. The next section, on
.pdfhref L -D building -A , Building the Document
I actually wrote first, and really rather quickly. I mean, it's just regurgitating some facts about
invoking the \fCgroff\fP program with some options; hardly requiring any significant cognition. But
it was a lot \fIeasier\fP.
.LP
I wonder if it comes down to focus. When I'm writing an introduction or abstract, I'm trying to
maintain some amount of generality about the topic. Maybe I find that harder because I'm not
focusing in on a detailed part of the whole. Maybe this is something we all suffer with, or maybe
it's something that programmers develop. I don't know. I'm just rambling now.
.LP
Yep, rambing. That's what I'm doing. I'm just padding out this document with some filler text to give
it some substance. I mean, it's not like I can just write a document with the same paragraph
repeated over and over. That would be a bit silly, wouldn't it? I mean, who would do that? Perhaps
we should have some kind of nonsense generator that can output... Oh wait I can just use Lorem
Ipsum. Ah well.
.\" -----------------------------------------------------------------------------------------------
.\" We're starting a new section, so we want to first change the left header to match.
.ds LH \fBBuilding the Document\fP
.\" As we did before, we now add a page break for the new section, outputting our new header.
.bp
.\" Set the heading level and output a new heading for this section.
.NH 1
.XN -N building Building the Document
.LP
This document is built using the \fCtroff\fP (pronounced \fItee-roff\fP) typesetting tool that was a
common tool for Unix systems in the 1970s and 1980s. The \fCtroff\fP tool has a long and interesting
history, and features prominently in the early history of Unix. I highlight recommend investigating
yourself, and I'd suggest you start with the writings of Brian Kernighan.
.LP
Even though the days of the DOCUMENTERS WORKBENCH\[tm] are over, Troff lives on today in the form of
.pdfhref W -D https://www.gnu.org/software/groff/ -A , groff
a GNU implementation of the troff tool.
.LP
The process by which this PDF document is constructed is a simple one, and is outlined in the
following diagram:
.DS L
.PS
w = 0.6;
h = 0.4;
gap = 0.4;
A: box "Source File" "\fCdemo.ms\fP";
move right gap;
B: box "\fCsoelim\fP" wid w ht h;
move right (gap * 0.5);
C: box "\fCpic\fP" wid w ht h;
move right (gap * 0.5);
D: box "\fCtbl\fP" wid w ht h;
move right (gap * 0.5);
E: box "\fCgroff\fP" wid w ht h;
move right gap;
F: box "Output" "\fCdemo.pdf\fP";

lastx = B.nw.x - (gap * 0.5);
lasty = B.nw.y + (h * 0.5);
G: box dashed with .nw at (lastx, lasty) wid (5 * (gap * 0.5) + (4 * w)) ht (2 * h);
"\fCMakefile\fP" above at last box.n;

line -> from A.e to G.w;
line -> from G.e to F.w;
line -> from B.e to C.w;
line -> from C.e to D.w;
line -> from D.e to E.w;
.PE
.DE
.LP
The source for this document, contained entirely in the \fCdemo.ms\fP file, is passed through a
series of pre-processors common to the Unix troff family of typesetting tools. The \fCsoelim\fP
pre-processor removes any included files, \fCpic\fP processes the embedded diagrams, \fCtbl\fP
processes the embedded tables, and \fCgroff\fP processes the document into a final output format.
.NH 2
.XN -N turth The Real Truth
.LP
Of course, I'm telling a bit of a lie here\**: it's not the \fCMakefile\fP that is passing the
document through these pre-processors, but rather the \fCgroff\fP program itself. If we take a look
at the \fCMakefile\fP we can see this is the case.
.FS
I can't be blamed for lying: I did say earlier on in the
.pdfhref L -D intro introduction
that I'd be padding this document out with some filler text to give it some substance.
.FE
.DS
.fam C
%.pdf: %.ms
	cat $< | ${TROFF} ${TROFF_OPTS} | ./toc-rel.sh > $@
.fam
.DE
.LP
The above extract from the \fCMakefile\fP matches any output with a \fC.pdf\fP extension to a
\fC.ms\fP file of the same name. It then passes the \fC.ms\fP file through the \fCgroff\fP program
with some options and a post-processor script, \fCtoc-rel.sh\fP, to generate the final output.
Those options are defined in the \fCMakefile\fP in the \fCTOFFF_OPTS\fP variable as follows:
.DS
.fam C
TROFF_OPTS=-Kutf8 -Tpdf -dpaper=a4 -P-pa4 -ms -mspdf -pdfmark -spt
.fam
.DE
.LP
At the end of the \fCTROFF_OPTS\fP value we can see the options: \fC-spt\fP. This tells \fCgroff\fP
that it should pass the source though the \fCsoelim\fP, \fCpic\fP, and \fCpic\fP pre-processors
prior to generating the final output.
.NH 2
.XN -N options-to-groff Options to Groff
.LP
In our invocation of \fCgroff\fP we're passing a number of options, which are described by the
following table:
.DS C
.TS
allbox tab(|);
cb cb
lfC l
.
Option | Description
_
-Kutf8 | Use the UTF-8 character encoding.
-Tpdf | Generate a PDF output file.
-dpaper=a4 | Set the paper size to A4.
-P-pa4 | Set the page size to A4.
-ms | Use the \fCms\fP macro package.
-mspdf | Use the \fCmspdf\fP macro package.
-pdfmark | Enable PDFmark support.
-spt | Pass the source through the \fCsoelim\fP, \fCpic\fP, and \fCtbl\fP pre-processors.
.TE
.DE
.LP
These options are passed to \fCgroff\fP to generate the final PDF output. The \fC-spt\fP option is
the most important, as it tells \fCgroff\fP to pass the source through the pre-processors that
handle included files, diagrams, and tables. In fact, it is because of \fCtbl\fP that the above
table is able to be included in this document.
.\" -----------------------------------------------------------------------------------------------
.\" Generate the table of contents
.\" -----------------------------------------------------------------------------------------------
.\" Clear the left header text (previously contained our section title)
.ds LH
.\" Add a page break to move the TOC to the next page
.bp
.\" Clear the left footer text (previously contained our page numbers)
.ds LF
.\" Emit the TOC via .PX after setting the page number back to zero and the page number format to
.\" lower-case Roman numerals.
.TC
