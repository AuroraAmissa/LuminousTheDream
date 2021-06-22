#!/bin/bash

lyx "Luminous: the Dream.lyx" -E xetex "Luminous: the Dream.tex"
latexmk -xelatex "Luminous: the Dream.tex"
