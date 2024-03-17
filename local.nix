{ ... }:

{
    name = "LuminousTheDream";
    releaseVersion = "0.1";

    distArcName = "LuminousTheDream";
    folderName = "Luminous the Dream";
    sourceArcName = "LuminousSources";

    buildScripts = ''
        mkdir -p /build/out/"Character Sheets"

        # Luminous
        render_pdf Book_Luminous "" "Luminous the Dream$FILE_VERSION_SUFFIX"
        render_pdf Book_Luminous_Crossover "" "Luminous the Dream - Crossing Paths$FILE_VERSION_SUFFIX"
        render_pdf Sheet_Luminous "Character Sheets/" "Luminous" --assemble=y --form=y --annotate=y

        # Maou
        #render_pdf Book_Maou "" "Maou the Lineage$FILE_VERSION_SUFFIX"
    '';
}