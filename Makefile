NAME := main
TEXS := $(wildcard *.tex)
SECTEXS := $(wildcard sections/*.tex)
TABLES := $(wildcard tables/*.tex)
NUMBERS := $(wildcard numbers/*.tex)
PLOTS := $(wildcard data/plots/*.eps)
CODE := $(wildcard code/*.tex)
FIGS := $(wildcard figures/*.pdf)
BIBS := $(wildcard *.bib)
DEPENDENCIES := ${TEXS} ${TABLES} ${NUMBERS} ${BIBS} ${CODE} ${PLOTS}

SYNCTEX ?= 0
SHELL_ESCAPE ?= 0
NONSTOPMODE ?= 0

ifeq (${SYNCTEX},1)
SYNCTEX_OPTION := -synctex=1
endif

ifeq (${SHELL_ESCAPE},1)
SHELL_ESCAPE_OPTION := -shell-escape
endif

ifeq (${NONSTOPMODE},1)
NONSTOPMODE_OPTION := -interaction=nonstopmode
endif

OUTPUT_DIR=.
TARGET=$(OUTPUT_DIR)/${NAME}.pdf

LATEX_OPTIONS := ${SYNCTEX_OPTION} ${SHELL_ESCAPE_OPTION} ${NONSTOPMODE_OPTION} -file-line-error --output-directory=$(OUTPUT_DIR)

%.pdf: %.fig 
	fig2dev -L eps -f Roman $*.fig >$*.eps

all: ${TARGET}

$(TARGET): ${DEPENDENCIES}
	-pdflatex ${LATEX_OPTIONS} $(NAME)
	-biber $(OUTPUT_DIR)/$(NAME)
	-pdflatex ${LATEX_OPTIONS} $(NAME)
	-pdflatex ${LATEX_OPTIONS} $(NAME)
	@echo '****************************************************************'
	@echo '******** Did you spell-check the paper? ********'

clean:
	cd $(OUTPUT_DIR) && ls $(NAME)* | grep -v ".tex" | grep -v ".bib" | xargs rm -f
	cd $(OUTPUT_DIR) && rm -f *.bak *~ *_latexmk *.synctex.gz*

