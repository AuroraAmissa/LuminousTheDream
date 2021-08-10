PackageOptions xcolor table
PackageOptions todonotes colorinlistoftodos

InsetLayout Flex:IgnoreThis
  LyXType               custom
  Decoration            classic
  LabelString           "Do not Render"
  LatexType             command
  LatexName             ignorethis
  ResetsFont            true
End

InsetLayout Flex:Sidebar
  LyXType               custom
  Decoration            classic
  LabelString           "Sidebar"
  LatexType             environment
  LatexName             lumsidebar
  Argument 1
    LabelString         "Title"
    Mandatory	    1
  EndArgument
  ResetsFont            true
End

InsetLayout Flex:Commentary
  LyXType               custom
  Decoration            classic
  LabelString           "Commentary"
  LatexType             environment
  LatexName             lumcommentary
  ResetsFont            true
  BgColor               pink
End

InsetLayout Flex:ContentWarning
  LyXType               custom
  Decoration            classic
  LabelString           "Content Warning"
  LatexType             environment
  LatexName             cw-sidebarenv
  ResetsFont            true
End

InsetLayout Flex:TwoColumnBox
  LyXType               custom
  Decoration            classic
  LabelString           "Two Columns"
  LatexType             environment
  LatexName             twocolumnbox
  ResetsFont            true
End

InsetLayout Flex:NewCommand
  LyXType               custom
  Decoration            classic
  LabelString           "New Command"
  LatexType             command
  LatexName             newcommand
  ResetsFont            true
  Argument 1
    LabelString         "Command"
    Mandatory	    1
    PassThruChars       "\[]{}_"
  EndArgument
  Argument 2
    LabelString         "Argument Count"
  EndArgument
End
