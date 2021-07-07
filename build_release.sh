#!/bin/bash

cp "Luminous: the Dream.lyx" "LtD_Release.lyx"
sed -i "s/usepackage\\[mark/usepackage[/g" "LtD_Release.lyx"
sed -i "s/%%DRAFT%%//g" "LtD_Release.lyx"
lyx "LtD_Release.lyx" -E pdf4 "LtD_Release_Temp.pdf"
qpdf "LtD_Release_Temp.pdf" "LtD_Release.pdf" \
    --compress-streams=n --object-streams=generate --coalesce-contents --optimize-images
