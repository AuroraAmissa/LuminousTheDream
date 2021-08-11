#!/bin/bash

echo "Building Luminous distribution..."

echo " - Creating directory structure"
rm -rf build || exit 1
mkdir -p build/out/"Bonus Files" || exit 1
mkdir -p build/tex || exit 1
mkdir -p dist || exit 1

echo " - Linking in external files"
ln -s ../fonts build/fonts || exit 1
ln -s ../includes build/includes || exit 1

echo " - Copying in .lyx files"
cp *.lyx build || exit 1

echo " - Disabling all branches"
sed -i -e '/\\branch .*/,+1s/\\selected.*/\\selected 0/' build/*.lyx || exit 1

activate_branch() {
    sed -i -e '/\\branch '$2'.*/,+1s/\\selected.*/\\selected 1/' "build/$1.lyx" || exit 1
}
render_luminous() {
    # Creates the direct output PDF
    lyx -v "build/$1.lyx" -E pdf4 "build/$1_Temp.pdf" || exit 1
    
    # Encrypt and recompress the PDF. This isn't really used for any real security, it's just here to avoid accidental modification.
    # Also to encourge anyone who wants to fork or do other weird stuff to *actually* use LyX instead of some weird PDF editor...
    qpdf "build/$1_Temp.pdf" "build/$1.pdf" \
        --compress-streams=y --object-streams=generate --coalesce-contents \
        --encrypt "" "pls dont do anything weird with the password :( :(" 128 \
        --extract=y --assemble=n --annotate=n --form=n --modify-other=n --print=full --modify=none --cleartext-metadata -- || exit 1
    cp "build/$1.pdf" "build/out/$2$3.pdf" || exit 1
    
    # Build an epub
    # Currently disabled because formatting these things is a right pain.
    #cd build
    #tex4ebook -xt -f epub3 "$1.tex" || exit 1
    #cd ..
    #cp "build/$1.epub" "build/out/$2$3.epub" || exit 1
}
create_archive() {
    cd build/out
    zip -r "$1.zip" * || exit 1
    mv "$1.zip" ../../dist || exit 1
    cd ../..
}

VERSION="$(git describe --tags --long --always --match '[0-9]*.*')"
ZVERSION="v$VERSION"

case $1 in
release)
    activate_branch Format_Common Release || exit 1
    FILE_MARKER=""
    ZIP_FILE_BIND=""
;;
playtest)
    activate_branch Format_Common Playtest || exit 1
    FILE_MARKER=" Playtest"
    ZIP_FILE_BIND=" - Playtest"
;;
ci)
    if [ ! -z "$BUILD_NUMBER" ]; then
        ZVERSION="r$BUILD_NUMBER"
    fi
    
    activate_branch Format_Common CiBuild || exit 1
    FILE_MARKER=" Draft"
    ZIP_FILE_BIND=" - Draft"
;;
*)
    FILE_MARKER=" Draft"
    ZIP_FILE_BIND=" - Draft"
;;
esac

render_luminous Book_Luminous "" "Luminous the Dream$FILE_MAKER" || exit 1
render_luminous Book_Luminous_Comm "Bonus Files/" "Luminous the Dream$FILE_MARKER (Author Commentary)" || exit 1
create_archive "Luminous the Dream$ZIP_FILE_BIND $ZVERSION" || exit 1
