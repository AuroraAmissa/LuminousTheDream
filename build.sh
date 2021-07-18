#!/bin/bash

echo "Building Luminous distribution..."

rm -rfv build || exit 1
mkdir -vp build/out/"Bonus Files" || exit 1
mkdir -vp build/sources || exit 1
mkdir -vp build/tex || exit 1
mkdir -vp dist || exit 1
ln -s ../fonts build/fonts || exit 1

copy_luminous_lyx() {
    cp "Luminous the Dream.lyx" "build/$1.lyx" || exit 1
    sed -i -e '/\\branch .*/,+1s/\\selected.*/\\selected 0/' "build/$1.lyx" || exit 1
}
activate_branch() {
    sed -i -e '/\\branch '$2'.*/,+1s/\\selected.*/\\selected 1/' "build/$1.lyx" || exit 1
}
render_luminous() {
    # Create .tex output
    lyx "build/$1.lyx" -E xetex "build/$1.tex" || exit 1
    cp "build/$1.tex" "build/sources/$3.tex" || exit 1

    # Creates the direct output PDF
    lyx "build/$1.lyx" -E pdf4 "build/$1_Temp.pdf" || exit 1
    
    # Encrypt and recompress the PDF. This isn't really used for any real security, it's just here to avoid accidental modification.
    # Also to encourge anyone who wants to fork or do other weird stuff to *actually* use LyX instead of some weird PDF editor...
    qpdf "build/$1_Temp.pdf" "build/$1.pdf" \
        --compress-streams=y --object-streams=generate --coalesce-contents --optimize-images \
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
    cp -rf fonts build.sh *.md build/sources || exit 1
    rm build/sources/fonts/*.ttf || exit 1
    mkdir "build/sources/.git" || exit 1
    cp .git/gitHeadInfo.gin build/sources/.git || exit 1

    mv "build/sources" "build/Luminous the Dream Sources - Revision $VERSION" || exit 1
    cd build
    tar --xz -cvf "out/Bonus Files/LuminousSources-$VERSION.tar.xz" "Luminous the Dream Sources - Revision $VERSION" || exit 1
    cd ..

    cd build/out
    zip -r "$1.zip" * || exit 1
    mv "$1.zip" ../../dist || exit 1
    cd ../..
}

VERSION="$(git describe --tags --long --always --match '[0-9]*.*')"

copy_luminous_lyx LtD || exit 1
copy_luminous_lyx LtDComm || exit 1
activate_branch LtDComm Commentary || exit 1

ZVERSION="v$VERSION"

case $1 in
release)
    activate_branch LtD Release || exit 1
    activate_branch LtDComm Release || exit 1    
    FILE_MARKER=""
    ZIP_FILE_BIND=""
;;
playtest)
    activate_branch LtD Playtest || exit 1
    activate_branch LtDComm Playtest || exit 1    
    FILE_MARKER=" Playtest"
    ZIP_FILE_BIND=" - Playtest"
;;
ci)
    if [ ! -z "$BUILD_NUMBER" ]; then
        ZVERSION="r$BUILD_NUMBER"
    fi
    
    activate_branch LtD CiBuild || exit 1
    activate_branch LtDComm CiBuild || exit 1    
    FILE_MARKER=" Draft"
    ZIP_FILE_BIND=" - Draft"
;;
*)
    FILE_MARKER=" Draft"
    ZIP_FILE_BIND=" - Draft"
;;
esac

render_luminous LtD "" "Luminous the Dream$FILE_MAKER" || exit 1
render_luminous LtDComm "Bonus Files/" "Luminous the Dream$FILE_MARKER (Author Commentary)" || exit 1
create_archive "Luminous the Dream$ZIP_FILE_BIND $ZVERSION" || exit 1
