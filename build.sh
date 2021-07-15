#!/bin/bash

echo "Building Luminous distribution..."

rm -rfv build || exit 1
mkdir -vp build/out/"Bonus Files" || exit 1
mkdir -vp build/sources || exit 1
mkdir -vp build/tex || exit 1
mkdir -vp dist || exit 1
ln -s ../fonts build/fonts || exit 1

copy_luminous_lyx() {
    cp "Luminous: the Dream.lyx" "build/$1.lyx"
}
activate_tag() {
    sed -i "s/%%REMOVE_FOR_$2%%//g" "build/$1.lyx"
}
render_luminous() {
    lyx "build/$1.lyx" -E xetex "build/sources/$3.tex"
    lyx "build/$1.lyx" -E pdf4 "build/$1_Temp.pdf"
    # Encrypt and recompress the PDF. This isn't really used for any real security, it's just here to avoid accidental modification.
    # Also to encourge anyone who wants to fork or do other weird stuff to *actually* use LyX instead of some weird PDF editor...
    qpdf "build/$1_Temp.pdf" "build/$1.pdf" \
        --compress-streams=y --object-streams=generate --coalesce-contents --optimize-images \
        --encrypt "" "9ZO7HECFROSRwJrVAIFC9j80apmnKSyQ" 128 \
        --extract=y --assemble=n --annotate=n --form=n --modify-other=n --print=full --modify=none --cleartext-metadata --
    cp "build/$1.pdf" "build/out/$2$3.pdf"
}
create_archive() {
    cp -rf fonts build.sh *.md "Luminous: the Dream.lyx" build/sources
    rm build/sources/fonts/*.ttf
    mkdir "build/sources/.git"
    cp .git/gitHeadInfo.gin build/sources/.git

    mv "build/sources" "build/Luminous: the Dream Sources - Revision $VERSION"
    cd build
    tar --xz -cvf "out/Bonus Files/LuminousSources-$VERSION.tar.xz" "Luminous: the Dream Sources - Revision $VERSION"
    cd ..

    cd build/out
    zip -r "$1.zip" *
    mv "$1.zip" ../../dist
    cd ../..
}

VERSION="$(git describe --tags --long --always --match '[0-9]*.*')"

case $1 in
release)
    copy_luminous_lyx LtD
    activate_tag LtD RELEASE
    activate_tag LtD NO_COMMENTARY
    render_luminous LtD "" "Luminous: the Dream"

    copy_luminous_lyx LtDComm
    activate_tag LtDComm RELEASE
    render_luminous LtDComm "Bonus Files/" "Luminous: the Dream (Author Commentary)"
    
    create_archive "Luminous: the Dream - Release $VERSION"
;;
playtest)
    copy_luminous_lyx LtD
    activate_tag LtD PLAYTEST
    activate_tag LtD NO_COMMENTARY
    render_luminous LtD "" "Luminous: the Dream Playtest"

    copy_luminous_lyx LtDComm
    activate_tag LtDComm PLAYTEST
    render_luminous LtDComm "Bonus Files/" "Luminous: the Dream Playtest (Author Commentary)"
    
    create_archive "Luminous: the Dream - Playtest $VERSION"
;;
*)
    copy_luminous_lyx LtD
    activate_tag LtD NO_COMMENTARY
    render_luminous LtD "" "Luminous: the Dream Draft"

    copy_luminous_lyx LtDComm
    render_luminous LtDComm "Bonus Files/" "Luminous: the Dream Draft (Author Commentary)"
    
    create_archive "Luminous: the Dream - Draft $VERSION"
;;
esac

