#!/bin/bash

cp "Luminous: the Dream.lyx" "Luminous: the Dream - Release.lyx"
sed -i "s/,draft,___draft_marker___//g" "Luminous: the Dream - Release.lyx"
lyx "Luminous: the Dream - Release.lyx" -E pdf4 "Luminous: the Dream - Release.pdf"

