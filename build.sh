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
}
activate_tag() {
    sed -i "s/%%REMOVE_FOR_$2%%//g" "build/$1.lyx" || exit 1
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

case $1 in
release)
    copy_luminous_lyx LtD || exit 1
    activate_tag LtD RELEASE || exit 1
    activate_tag LtD NO_COMMENTARY || exit 1
    render_luminous LtD "" "Luminous the Dream" || exit 1

    copy_luminous_lyx LtDComm || exit 1
    activate_tag LtDComm RELEASE || exit 1
    render_luminous LtDComm "Bonus Files/" "Luminous the Dream (Author Commentary)" || exit 1
    
    create_archive "Luminous the Dream v$VERSION" || exit 1
;;
playtest)
    copy_luminous_lyx LtD || exit 1
    activate_tag LtD PLAYTEST || exit 1
    activate_tag LtD NO_COMMENTARY || exit 1
    render_luminous LtD "" "Luminous the Dream Playtest" || exit 1

    copy_luminous_lyx LtDComm || exit 1
    activate_tag LtDComm PLAYTEST || exit 1
    render_luminous LtDComm "Bonus Files/" "Luminous the Dream Playtest (Author Commentary)" || exit 1
    
    create_archive "Luminous the Dream - Playtest v$VERSION" || exit 1
;;
*)
    if [ ! -z "$BUILD_NUMBER" ]; then
        ZVERSION="r$BUILD_NUMBER"
    else
        ZVERSION="v$VERSION"
    fi

    copy_luminous_lyx LtD || exit 1
    activate_tag LtD NO_COMMENTARY || exit 1
    render_luminous LtD "" "Luminous the Dream Draft" || exit 1

    copy_luminous_lyx LtDComm || exit 1
    render_luminous LtDComm "Bonus Files/" "Luminous the Dream Draft (Author Commentary)" || exit 1
    
    create_archive "Luminous the Dream - Draft $ZVERSION" || exit 1
;;
esac
