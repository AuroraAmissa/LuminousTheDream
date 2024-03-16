{ ... }:

{
    distArcName = "Luminous the Dream";
    sourceArcName = "LuminousSources";

    buildScripts = ''
        mkdir -p /build/out/"Character Sheets" || exit 1

        # Luminous
        render_pdf Book_Luminous "" "Luminous the Dream$FILE_VERSION_SUFFIX" || exit 1
        render_pdf Book_Luminous_Crossover "" "Luminous the Dream - Crossing Paths$FILE_VERSION_SUFFIX" || exit 1
        render_pdf Sheet_Luminous "Character Sheets/" "Luminous" --assemble=y --form=y --annotate=y || exit 1

        # Maou
        #render_pdf Book_Maou "" "Maou the Lineage$FILE_VERSION_SUFFIX" || exit 1
    '';
}