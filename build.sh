#!/bin/bash

. RulebookShared/build_common.sh
SOURCE_NAME="LuminousSources"

echo "Building Luminous distribution..."
init_build $1 || exit 1

echo " - Creating Luminous-specific directories..."
mkdir -p build/out/"Bonus Files" || exit 1
mkdir -p build/out/"Character Sheets" || exit 1

render_pdf Book_Luminous "" "Luminous the Dream$FILE_MAKER" || exit 1
render_pdf Book_Luminous_Comm "Bonus Files/" "Luminous the Dream$FILE_MARKER (Author Commentary)" || exit 1
render_pdf Sheet_Luminous "Character Sheets/" "Luminous" --assemble=y --form=y --annotate=y || exit 1
create_archive "Luminous the Dream$ZIP_FILE_BIND $ZVERSION" || exit 1
create_source_archive "LuminousSources$ZIP_FILE_BIND $ZVERSION" || exit 1
