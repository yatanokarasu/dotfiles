#!/bin/bash

shopt -s extglob


################################################################################
# CUSTOMIZABLE
################################################################################

__BASH_PL_MODULES=(
    newline
    time user host cwd rodir newline
    aws terraform python k8s docker git
    bgjobs prompt error
)

declare -A __BASH_PL_MODULE_COLORS=(
    #format = fg;bg[;attr[,attr,...]]
    #
    # - fg/gg:Default,Black,White
    #         Red,Green,Yellow,Blue,Magenta,Cyan,Gray
    #         Light**(above)
    #
    # - attr: Reset,Bold,Italic,Underline,Blink,Reverse,Hidden
    #                                        ^
    [aws]="DarkOrange;Grey15;Bold"
    [bgjobs]="White;Grey11;Bold"
    [cwd]="SteelBlue1;Grey35;Bold"
    [docker]="White;DeepSkyBlue1;Bold"
    [error]="White;Red1;Bold"
    [git]="White;Grey0;Bold"
    [host]="LightSteelBlue;Grey30;Bold"
    [k8s]="White;DodgerBlue2;Bold"
    [prompt]="White;Grey27;Bold"
    [python]="Olive;DodgerBlue1;Bold"
    [rodir]="White;Red3;Bold"
    [terraform]="White;SlateBlue1;Bold"
    [time]="Grey74;Grey19;Bold"
    [user]="Green;Grey23;Bold"

    # DO NOT MODIFY
    [newline]="Default;Default"
)



################################################################################
# CONSTANTS
################################################################################

declare -A __BASH_PL_FG_COLORS=(
    [Default]=""
    [Black]="\[\e[38;05;0m\]"               # #000000
    [Maroon]="\[\e[38;05;1m\]"              # #800000
    [Green]="\[\e[38;05;2m\]"               # #008000
    [Olive]="\[\e[38;05;3m\]"               # #808000
    [Navy]="\[\e[38;05;4m\]"                # #000080
    [Purple]="\[\e[38;05;5m\]"              # #800080
    [Teal]="\[\e[38;05;6m\]"                # #008080
    [Silver]="\[\e[38;05;7m\]"              # #c0c0c0
    [Grey]="\[\e[38;05;8m\]"                # #808080
    [Red]="\[\e[38;05;9m\]"                 # #ff0000
    [Lime]="\[\e[38;05;10m\]"               # #00ff00
    [Yellow]="\[\e[38;05;11m\]"             # #ffff00
    [Blue]="\[\e[38;05;12m\]"               # #0000ff
    [Fuchsia]="\[\e[38;05;13m\]"            # #ff00ff
    [Aqua]="\[\e[38;05;14m\]"               # #00ffff
    [White]="\[\e[38;05;15m\]"              # #ffffff
    [Grey0]="\[\e[38;05;16m\]"              # #000000
    [NavyBlue]="\[\e[38;05;17m\]"           # #00005f
    [DarkBlue]="\[\e[38;05;18m\]"           # #000087
    [Blue4]="\[\e[38;05;19m\]"              # #0000af
    [Blue3]="\[\e[38;05;20m\]"              # #0000d7
    [Blue1]="\[\e[38;05;21m\]"              # #0000ff
    [DarkGreen]="\[\e[38;05;22m\]"          # #005f00
    [DeepSkyBlue7]="\[\e[38;05;23m\]"       # #005f5f
    [DeepSkyBlue6]="\[\e[38;05;24m\]"       # #005f87
    [DeepSkyBlue5]="\[\e[38;05;25m\]"       # #005faf
    [DodgerBlue3]="\[\e[38;05;26m\]"        # #005fd7
    [DodgerBlue2]="\[\e[38;05;27m\]"        # #005fff
    [Green4]="\[\e[38;05;28m\]"             # #008700
    [SpringGreen6]="\[\e[38;05;29m\]"       # #00875f
    [Turquoise4]="\[\e[38;05;30m\]"         # #008787
    [DeepSkyBlue4]="\[\e[38;05;31m\]"       # #0087af
    [DeepSkyBlue3]="\[\e[38;05;32m\]"       # #0087d7
    [DodgerBlue1]="\[\e[38;05;33m\]"        # #0087ff
    [Green3]="\[\e[38;05;34m\]"             # #00af00
    [SpringGreen5]="\[\e[38;05;35m\]"       # #00af5f
    [DarkCyan]="\[\e[38;05;36m\]"           # #00af87
    [LightSeaGreen]="\[\e[38;05;37m\]"      # #00afaf
    [DeepSkyBlue2]="\[\e[38;05;38m\]"       # #00afd7
    [DeepSkyBlue1]="\[\e[38;05;39m\]"       # #00afff
    [Green2]="\[\e[38;05;40m\]"             # #00d700
    [SpringGreen4]="\[\e[38;05;41m\]"       # #00d75f
    [SpringGreen3]="\[\e[38;05;42m\]"       # #00d787
    [Cyan3]="\[\e[38;05;43m\]"              # #00d7af
    [DarkTurquoise]="\[\e[38;05;44m\]"      # #00d7d7
    [Turquoise2]="\[\e[38;05;45m\]"         # #00d7ff
    [Green1]="\[\e[38;05;46m\]"             # #00ff00
    [SpringGreen2]="\[\e[38;05;47m\]"       # #00ff5f
    [SpringGreen1]="\[\e[38;05;48m\]"       # #00ff87
    [MediumSpringGreen]="\[\e[38;05;49m\]"  # #00ffaf
    [Cyan2]="\[\e[38;05;50m\]"              # #00ffd7
    [Cyan1]="\[\e[38;05;51m\]"              # #00ffff
    [DarkRed1]="\[\e[38;05;52m\]"           # #5f0000
    [DeepPink8]="\[\e[38;05;53m\]"          # #5f005f
    [Purple5]="\[\e[38;05;54m\]"            # #5f0087
    [Purple4]="\[\e[38;05;55m\]"            # #5f00af
    [Purple3]="\[\e[38;05;56m\]"            # #5f00d7
    [BlueViolet]="\[\e[38;05;57m\]"         # #5f00ff
    [Orange2]="\[\e[38;05;58m\]"            # #5f5f00
    [Grey37]="\[\e[38;05;59m\]"             # #5f5f5f
    [MediumPurple7]="\[\e[38;05;60m\]"      # #5f5f87
    [SlateBlue4]="\[\e[38;05;61m\]"         # #5f5faf
    [SlateBlue3]="\[\e[38;05;62m\]"         # #5f5fd7
    [RoyalBlue1]="\[\e[38;05;63m\]"         # #5f5fff
    [Chartreuse6]="\[\e[38;05;64m\]"        # #5f8700
    [DarkSeaGreen9]="\[\e[38;05;65m\]"      # #5f875f
    [PaleTurquoise4]="\[\e[38;05;66m\]"     # #5f8787
    [SteelBlue]="\[\e[38;05;67m\]"          # #5f87af
    [SteelBlue3]="\[\e[38;05;68m\]"         # #5f87d7
    [CornflowerBlue]="\[\e[38;05;69m\]"     # #5f87ff
    [Chartreuse5]="\[\e[38;05;70m\]"        # #5faf00
    [DarkSeaGreen8]="\[\e[38;05;71m\]"      # #5faf5f
    [CadetBlue2]="\[\e[38;05;72m\]"         # #5faf87
    [CadetBlue]="\[\e[38;05;73m\]"          # #5fafaf
    [SkyBlue3]="\[\e[38;05;74m\]"           # #5fafd7
    [SteelBlue2]="\[\e[38;05;75m\]"         # #5fafff
    [Chartreuse4]="\[\e[38;05;76m\]"        # #5fd700
    [PaleGreen4]="\[\e[38;05;77m\]"         # #5fd75f
    [SeaGreen4]="\[\e[38;05;78m\]"          # #5fd787
    [Aquamarine3]="\[\e[38;05;79m\]"        # #5fd7af
    [MediumTurquoise]="\[\e[38;05;80m\]"    # #5fd7d7
    [SteelBlue1]="\[\e[38;05;81m\]"         # #5fd7ff
    [Chartreuse3]="\[\e[38;05;82m\]"        # #5fff00
    [SeaGreen3]="\[\e[38;05;83m\]"          # #5fff5f
    [SeaGreen2]="\[\e[38;05;84m\]"          # #5fff87
    [SeaGreen1]="\[\e[38;05;85m\]"          # #5fffaf
    [Aquamarine2]="\[\e[38;05;86m\]"        # #5fffd7
    [DarkSlateGray2]="\[\e[38;05;87m\]"     # #5fffff
    [DarkRed]="\[\e[38;05;88m\]"            # #870000
    [DeepPink7]="\[\e[38;05;89m\]"          # #87005f
    [DarkMagenta2]="\[\e[38;05;90m\]"       # #870087
    [DarkMagenta]="\[\e[38;05;91m\]"        # #8700af
    [DarkViolet1]="\[\e[38;05;92m\]"        # #8700d7
    [Purple2]="\[\e[38;05;93m\]"            # #8700ff
    [DarkOrange3]="\[\e[38;05;94m\]"        # #875f00
    [LightPink4]="\[\e[38;05;95m\]"         # #875f5f
    [Plum4]="\[\e[38;05;96m\]"              # #875f87
    [MediumPurple6]="\[\e[38;05;97m\]"      # #875faf
    [MediumPurple5]="\[\e[38;05;98m\]"      # #875fd7
    [SlateBlue1]="\[\e[38;05;99m\]"         # #875fff
    [Yellow6]="\[\e[38;05;100m\]"           # #878700
    [Wheat4]="\[\e[38;05;101m\]"            # #87875f
    [Grey53]="\[\e[38;05;102m\]"            # #878787
    [LightSlateGrey]="\[\e[38;05;103m\]"    # #8787af
    [MediumPurple4]="\[\e[38;05;104m\]"     # #8787d7
    [LightSlateBlue]="\[\e[38;05;105m\]"    # #8787ff
    [Yellow5]="\[\e[38;05;106m\]"           # #87af00
    [DarkOliveGreen6]="\[\e[38;05;107m\]"   # #87af5f
    [DarkSeaGreen7]="\[\e[38;05;108m\]"     # #87af87
    [LightSkyBlue4]="\[\e[38;05;109m\]"     # #87afaf
    [LightSkyBlue3]="\[\e[38;05;110m\]"     # #87afd7
    [SkyBlue2]="\[\e[38;05;111m\]"          # #87afff
    [Chartreuse2]="\[\e[38;05;112m\]"       # #87d700
    [DarkOliveGreen5]="\[\e[38;05;113m\]"   # #87d75f
    [PaleGreen3]="\[\e[38;05;114m\]"        # #87d787
    [DarkSeaGreen6]="\[\e[38;05;115m\]"     # #87d7af
    [DarkSlateGray3]="\[\e[38;05;116m\]"    # #87d7d7
    [SkyBlue1]="\[\e[38;05;117m\]"          # #87d7ff
    [Chartreuse1]="\[\e[38;05;118m\]"       # #87ff00
    [LightGreen2]="\[\e[38;05;119m\]"       # #87ff5f
    [LightGreen]="\[\e[38;05;120m\]"        # #87ff87
    [PaleGreen2]="\[\e[38;05;121m\]"        # #87ffaf
    [Aquamarine1]="\[\e[38;05;122m\]"       # #87ffd7
    [DarkSlateGray1]="\[\e[38;05;123m\]"    # #87ffff
    [Red3]="\[\e[38;05;124m\]"              # #af0000
    [DeepPink6]="\[\e[38;05;125m\]"         # #af005f
    [MediumVioletRed]="\[\e[38;05;126m\]"   # #af0087
    [Magenta6]="\[\e[38;05;127m\]"          # #af00af
    [DarkViolet]="\[\e[38;05;128m\]"        # #af00d7
    [Purple1]="\[\e[38;05;129m\]"           # #af00ff
    [DarkOrange2]="\[\e[38;05;130m\]"       # #af5f00
    [IndianRed3]="\[\e[38;05;131m\]"        # #af5f5f
    [HotPink4]="\[\e[38;05;132m\]"          # #af5f87
    [MediumOrchid3]="\[\e[38;05;133m\]"     # #af5faf
    [MediumOrchid]="\[\e[38;05;134m\]"      # #af5fd7
    [MediumPurple3]="\[\e[38;05;135m\]"     # #af5fff
    [DarkGoldenrod]="\[\e[38;05;136m\]"     # #af8700
    [LightSalmon3]="\[\e[38;05;137m\]"      # #af875f
    [RosyBrown]="\[\e[38;05;138m\]"         # #af8787
    [Grey63]="\[\e[38;05;139m\]"            # #af87af
    [MediumPurple2]="\[\e[38;05;140m\]"     # #af87d7
    [MediumPurple1]="\[\e[38;05;141m\]"     # #af87ff
    [Gold3]="\[\e[38;05;142m\]"             # #afaf00
    [DarkKhaki]="\[\e[38;05;143m\]"         # #afaf5f
    [NavajoWhite3]="\[\e[38;05;144m\]"      # #afaf87
    [Grey69]="\[\e[38;05;145m\]"            # #afafaf
    [LightSteelBlue3]="\[\e[38;05;146m\]"   # #afafd7
    [LightSteelBlue]="\[\e[38;05;147m\]"    # #afafff
    [Yellow4]="\[\e[38;05;148m\]"           # #afd700
    [DarkOliveGreen4]="\[\e[38;05;149m\]"   # #afd75f
    [DarkSeaGreen5]="\[\e[38;05;150m\]"     # #afd787
    [DarkSeaGreen4]="\[\e[38;05;151m\]"     # #afd7af
    [LightCyan3]="\[\e[38;05;152m\]"        # #afd7d7
    [LightSkyBlue1]="\[\e[38;05;153m\]"     # #afd7ff
    [GreenYellow]="\[\e[38;05;154m\]"       # #afff00
    [DarkOliveGreen3]="\[\e[38;05;155m\]"   # #afff5f
    [PaleGreen1]="\[\e[38;05;156m\]"        # #afff87
    [DarkSeaGreen3]="\[\e[38;05;157m\]"     # #afffaf
    [DarkSeaGreen2]="\[\e[38;05;158m\]"     # #afffd7
    [PaleTurquoise1]="\[\e[38;05;159m\]"    # #afffff
    [Red2]="\[\e[38;05;160m\]"              # #d70000
    [DeepPink5]="\[\e[38;05;161m\]"         # #d7005f
    [DeepPink4]="\[\e[38;05;162m\]"         # #d70087
    [Magenta5]="\[\e[38;05;163m\]"          # #d700af
    [Magenta4]="\[\e[38;05;164m\]"          # #d700d7
    [Magenta3]="\[\e[38;05;165m\]"          # #d700ff
    [DarkOrange1]="\[\e[38;05;166m\]"       # #d75f00
    [IndianRed]="\[\e[38;05;167m\]"         # #d75f5f
    [HotPink3]="\[\e[38;05;168m\]"          # #d75f87
    [HotPink2]="\[\e[38;05;169m\]"          # #d75faf
    [Orchid]="\[\e[38;05;170m\]"            # #d75fd7
    [MediumOrchid2]="\[\e[38;05;171m\]"     # #d75fff
    [Orange1]="\[\e[38;05;172m\]"           # #d78700
    [LightSalmon2]="\[\e[38;05;173m\]"      # #d7875f
    [LightPink3]="\[\e[38;05;174m\]"        # #d78787
    [Pink3]="\[\e[38;05;175m\]"             # #d787af
    [Plum3]="\[\e[38;05;176m\]"             # #d787d7
    [Violet]="\[\e[38;05;177m\]"            # #d787ff
    [Gold2]="\[\e[38;05;178m\]"             # #d7af00
    [LightGoldenrod5]="\[\e[38;05;179m\]"   # #d7af5f
    [Tan]="\[\e[38;05;180m\]"               # #d7af87
    [MistyRose3]="\[\e[38;05;181m\]"        # #d7afaf
    [Thistle3]="\[\e[38;05;182m\]"          # #d7afd7
    [Plum2]="\[\e[38;05;183m\]"             # #d7afff
    [Yellow3]="\[\e[38;05;184m\]"           # #d7d700
    [Khaki3]="\[\e[38;05;185m\]"            # #d7d75f
    [LightGoldenrod4]="\[\e[38;05;186m\]"   # #d7d787
    [LightYellow3]="\[\e[38;05;187m\]"      # #d7d7af
    [Grey84]="\[\e[38;05;188m\]"            # #d7d7d7
    [LightSteelBlue1]="\[\e[38;05;189m\]"   # #d7d7ff
    [Yellow2]="\[\e[38;05;190m\]"           # #d7ff00
    [DarkOliveGreen2]="\[\e[38;05;191m\]"   # #d7ff5f
    [DarkOliveGreen1]="\[\e[38;05;192m\]"   # #d7ff87
    [DarkSeaGreen1]="\[\e[38;05;193m\]"     # #d7ffaf
    [Honeydew2]="\[\e[38;05;194m\]"         # #d7ffd7
    [LightCyan1]="\[\e[38;05;195m\]"        # #d7ffff
    [Red1]="\[\e[38;05;196m\]"              # #ff0000
    [DeepPink3]="\[\e[38;05;197m\]"         # #ff005f
    [DeepPink2]="\[\e[38;05;198m\]"         # #ff0087
    [DeepPink1]="\[\e[38;05;199m\]"         # #ff00af
    [Magenta2]="\[\e[38;05;200m\]"          # #ff00d7
    [Magenta1]="\[\e[38;05;201m\]"          # #ff00ff
    [OrangeRed1]="\[\e[38;05;202m\]"        # #ff5f00
    [IndianRed2]="\[\e[38;05;203m\]"        # #ff5f5f
    [IndianRed1]="\[\e[38;05;204m\]"        # #ff5f87
    [HotPink1]="\[\e[38;05;205m\]"          # #ff5faf
    [HotPink]="\[\e[38;05;206m\]"           # #ff5fd7
    [MediumOrchid1]="\[\e[38;05;207m\]"     # #ff5fff
    [DarkOrange]="\[\e[38;05;208m\]"        # #ff8700
    [Salmon1]="\[\e[38;05;209m\]"           # #ff875f
    [LightCoral]="\[\e[38;05;210m\]"        # #ff8787
    [PaleVioletRed1]="\[\e[38;05;211m\]"    # #ff87af
    [Orchid2]="\[\e[38;05;212m\]"           # #ff87d7
    [Orchid1]="\[\e[38;05;213m\]"           # #ff87ff
    [Orange]="\[\e[38;05;214m\]"            # #ffaf00
    [SandyBrown]="\[\e[38;05;215m\]"        # #ffaf5f
    [LightSalmon1]="\[\e[38;05;216m\]"      # #ffaf87
    [LightPink1]="\[\e[38;05;217m\]"        # #ffafaf
    [Pink1]="\[\e[38;05;218m\]"             # #ffafd7
    [Plum1]="\[\e[38;05;219m\]"             # #ffafff
    [Gold1]="\[\e[38;05;220m\]"             # #ffd700
    [LightGoldenrod3]="\[\e[38;05;221m\]"   # #ffd75f
    [LightGoldenrod2]="\[\e[38;05;222m\]"   # #ffd787
    [NavajoWhite1]="\[\e[38;05;223m\]"      # #ffd7af
    [MistyRose1]="\[\e[38;05;224m\]"        # #ffd7d7
    [Thistle1]="\[\e[38;05;225m\]"          # #ffd7ff
    [Yellow1]="\[\e[38;05;226m\]"           # #ffff00
    [LightGoldenrod1]="\[\e[38;05;227m\]"   # #ffff5f
    [Khaki1]="\[\e[38;05;228m\]"            # #ffff87
    [Wheat1]="\[\e[38;05;229m\]"            # #ffffaf
    [Cornsilk1]="\[\e[38;05;230m\]"         # #ffffd7
    [Grey100]="\[\e[38;05;231m\]"           # #ffffff
    [Grey3]="\[\e[38;05;232m\]"             # #080808
    [Grey7]="\[\e[38;05;233m\]"             # #121212
    [Grey11]="\[\e[38;05;234m\]"            # #1c1c1c
    [Grey15]="\[\e[38;05;235m\]"            # #262626
    [Grey19]="\[\e[38;05;236m\]"            # #303030
    [Grey23]="\[\e[38;05;237m\]"            # #3a3a3a
    [Grey27]="\[\e[38;05;238m\]"            # #444444
    [Grey30]="\[\e[38;05;239m\]"            # #4e4e4e
    [Grey35]="\[\e[38;05;240m\]"            # #585858
    [Grey39]="\[\e[38;05;241m\]"            # #626262
    [Grey42]="\[\e[38;05;242m\]"            # #6c6c6c
    [Grey46]="\[\e[38;05;243m\]"            # #767676
    [Grey50]="\[\e[38;05;244m\]"            # #808080
    [Grey54]="\[\e[38;05;245m\]"            # #8a8a8a
    [Grey58]="\[\e[38;05;246m\]"            # #949494
    [Grey62]="\[\e[38;05;247m\]"            # #9e9e9e
    [Grey66]="\[\e[38;05;248m\]"            # #a8a8a8
    [Grey70]="\[\e[38;05;249m\]"            # #b2b2b2
    [Grey74]="\[\e[38;05;250m\]"            # #bcbcbc
    [Grey78]="\[\e[38;05;251m\]"            # #c6c6c6
    [Grey82]="\[\e[38;05;252m\]"            # #d0d0d0
    [Grey85]="\[\e[38;05;253m\]"            # #dadada
    [Grey89]="\[\e[38;05;254m\]"            # #e4e4e4
    [Grey93]="\[\e[38;05;255m\]"            # #eeeeee
)

declare -A __BASH_PL_BG_COLORS=(
    [Default]=""
    [Black]="\[\e[48;05;0m\]"               # #000000
    [Maroon]="\[\e[48;05;1m\]"              # #800000
    [Green]="\[\e[48;05;2m\]"               # #008000
    [Olive]="\[\e[48;05;3m\]"               # #808000
    [Navy]="\[\e[48;05;4m\]"                # #000080
    [Purple]="\[\e[48;05;5m\]"              # #800080
    [Teal]="\[\e[48;05;6m\]"                # #008080
    [Silver]="\[\e[48;05;7m\]"              # #c0c0c0
    [Grey]="\[\e[48;05;8m\]"                # #808080
    [Red]="\[\e[48;05;9m\]"                 # #ff0000
    [Lime]="\[\e[48;05;10m\]"               # #00ff00
    [Yellow]="\[\e[48;05;11m\]"             # #ffff00
    [Blue]="\[\e[48;05;12m\]"               # #0000ff
    [Fuchsia]="\[\e[48;05;13m\]"            # #ff00ff
    [Aqua]="\[\e[48;05;14m\]"               # #00ffff
    [White]="\[\e[48;05;15m\]"              # #ffffff
    [Grey0]="\[\e[48;05;16m\]"              # #000000
    [NavyBlue]="\[\e[48;05;17m\]"           # #00005f
    [DarkBlue]="\[\e[48;05;18m\]"           # #000087
    [Blue4]="\[\e[48;05;19m\]"              # #0000af
    [Blue3]="\[\e[48;05;20m\]"              # #0000d7
    [Blue1]="\[\e[48;05;21m\]"              # #0000ff
    [DarkGreen]="\[\e[48;05;22m\]"          # #005f00
    [DeepSkyBlue7]="\[\e[48;05;23m\]"       # #005f5f
    [DeepSkyBlue6]="\[\e[48;05;24m\]"       # #005f87
    [DeepSkyBlue5]="\[\e[48;05;25m\]"       # #005faf
    [DodgerBlue3]="\[\e[48;05;26m\]"        # #005fd7
    [DodgerBlue2]="\[\e[48;05;27m\]"        # #005fff
    [Green4]="\[\e[48;05;28m\]"             # #008700
    [SpringGreen6]="\[\e[48;05;29m\]"       # #00875f
    [Turquoise4]="\[\e[48;05;30m\]"         # #008787
    [DeepSkyBlue4]="\[\e[48;05;31m\]"       # #0087af
    [DeepSkyBlue3]="\[\e[48;05;32m\]"       # #0087d7
    [DodgerBlue1]="\[\e[48;05;33m\]"        # #0087ff
    [Green3]="\[\e[48;05;34m\]"             # #00af00
    [SpringGreen5]="\[\e[48;05;35m\]"       # #00af5f
    [DarkCyan]="\[\e[48;05;36m\]"           # #00af87
    [LightSeaGreen]="\[\e[48;05;37m\]"      # #00afaf
    [DeepSkyBlue2]="\[\e[48;05;38m\]"       # #00afd7
    [DeepSkyBlue1]="\[\e[48;05;39m\]"       # #00afff
    [Green2]="\[\e[48;05;40m\]"             # #00d700
    [SpringGreen4]="\[\e[48;05;41m\]"       # #00d75f
    [SpringGreen3]="\[\e[48;05;42m\]"       # #00d787
    [Cyan3]="\[\e[48;05;43m\]"              # #00d7af
    [DarkTurquoise]="\[\e[48;05;44m\]"      # #00d7d7
    [Turquoise2]="\[\e[48;05;45m\]"         # #00d7ff
    [Green1]="\[\e[48;05;46m\]"             # #00ff00
    [SpringGreen2]="\[\e[48;05;47m\]"       # #00ff5f
    [SpringGreen1]="\[\e[48;05;48m\]"       # #00ff87
    [MediumSpringGreen]="\[\e[48;05;49m\]"  # #00ffaf
    [Cyan2]="\[\e[48;05;50m\]"              # #00ffd7
    [Cyan1]="\[\e[48;05;51m\]"              # #00ffff
    [DarkRed1]="\[\e[48;05;52m\]"           # #5f0000
    [DeepPink8]="\[\e[48;05;53m\]"          # #5f005f
    [Purple5]="\[\e[48;05;54m\]"            # #5f0087
    [Purple4]="\[\e[48;05;55m\]"            # #5f00af
    [Purple3]="\[\e[48;05;56m\]"            # #5f00d7
    [BlueViolet]="\[\e[48;05;57m\]"         # #5f00ff
    [Orange2]="\[\e[48;05;58m\]"            # #5f5f00
    [Grey37]="\[\e[48;05;59m\]"             # #5f5f5f
    [MediumPurple7]="\[\e[48;05;60m\]"      # #5f5f87
    [SlateBlue4]="\[\e[48;05;61m\]"         # #5f5faf
    [SlateBlue3]="\[\e[48;05;62m\]"         # #5f5fd7
    [RoyalBlue1]="\[\e[48;05;63m\]"         # #5f5fff
    [Chartreuse6]="\[\e[48;05;64m\]"        # #5f8700
    [DarkSeaGreen9]="\[\e[48;05;65m\]"      # #5f875f
    [PaleTurquoise4]="\[\e[48;05;66m\]"     # #5f8787
    [SteelBlue]="\[\e[48;05;67m\]"          # #5f87af
    [SteelBlue3]="\[\e[48;05;68m\]"         # #5f87d7
    [CornflowerBlue]="\[\e[48;05;69m\]"     # #5f87ff
    [Chartreuse5]="\[\e[48;05;70m\]"        # #5faf00
    [DarkSeaGreen8]="\[\e[48;05;71m\]"      # #5faf5f
    [CadetBlue2]="\[\e[48;05;72m\]"         # #5faf87
    [CadetBlue]="\[\e[48;05;73m\]"          # #5fafaf
    [SkyBlue3]="\[\e[48;05;74m\]"           # #5fafd7
    [SteelBlue2]="\[\e[48;05;75m\]"         # #5fafff
    [Chartreuse4]="\[\e[48;05;76m\]"        # #5fd700
    [PaleGreen4]="\[\e[48;05;77m\]"         # #5fd75f
    [SeaGreen4]="\[\e[48;05;78m\]"          # #5fd787
    [Aquamarine3]="\[\e[48;05;79m\]"        # #5fd7af
    [MediumTurquoise]="\[\e[48;05;80m\]"    # #5fd7d7
    [SteelBlue1]="\[\e[48;05;81m\]"         # #5fd7ff
    [Chartreuse3]="\[\e[48;05;82m\]"        # #5fff00
    [SeaGreen3]="\[\e[48;05;83m\]"          # #5fff5f
    [SeaGreen2]="\[\e[48;05;84m\]"          # #5fff87
    [SeaGreen1]="\[\e[48;05;85m\]"          # #5fffaf
    [Aquamarine2]="\[\e[48;05;86m\]"        # #5fffd7
    [DarkSlateGray2]="\[\e[48;05;87m\]"     # #5fffff
    [DarkRed]="\[\e[48;05;88m\]"            # #870000
    [DeepPink7]="\[\e[48;05;89m\]"          # #87005f
    [DarkMagenta2]="\[\e[48;05;90m\]"       # #870087
    [DarkMagenta]="\[\e[48;05;91m\]"        # #8700af
    [DarkViolet1]="\[\e[48;05;92m\]"        # #8700d7
    [Purple2]="\[\e[48;05;93m\]"            # #8700ff
    [DarkOrange3]="\[\e[48;05;94m\]"        # #875f00
    [LightPink4]="\[\e[48;05;95m\]"         # #875f5f
    [Plum4]="\[\e[48;05;96m\]"              # #875f87
    [MediumPurple6]="\[\e[48;05;97m\]"      # #875faf
    [MediumPurple5]="\[\e[48;05;98m\]"      # #875fd7
    [SlateBlue1]="\[\e[48;05;99m\]"         # #875fff
    [Yellow6]="\[\e[48;05;100m\]"           # #878700
    [Wheat4]="\[\e[48;05;101m\]"            # #87875f
    [Grey53]="\[\e[48;05;102m\]"            # #878787
    [LightSlateGrey]="\[\e[48;05;103m\]"    # #8787af
    [MediumPurple4]="\[\e[48;05;104m\]"     # #8787d7
    [LightSlateBlue]="\[\e[48;05;105m\]"    # #8787ff
    [Yellow5]="\[\e[48;05;106m\]"           # #87af00
    [DarkOliveGreen6]="\[\e[48;05;107m\]"   # #87af5f
    [DarkSeaGreen7]="\[\e[48;05;108m\]"     # #87af87
    [LightSkyBlue4]="\[\e[48;05;109m\]"     # #87afaf
    [LightSkyBlue3]="\[\e[48;05;110m\]"     # #87afd7
    [SkyBlue2]="\[\e[48;05;111m\]"          # #87afff
    [Chartreuse2]="\[\e[48;05;112m\]"       # #87d700
    [DarkOliveGreen5]="\[\e[48;05;113m\]"   # #87d75f
    [PaleGreen3]="\[\e[48;05;114m\]"        # #87d787
    [DarkSeaGreen6]="\[\e[48;05;115m\]"     # #87d7af
    [DarkSlateGray3]="\[\e[48;05;116m\]"    # #87d7d7
    [SkyBlue1]="\[\e[48;05;117m\]"          # #87d7ff
    [Chartreuse1]="\[\e[48;05;118m\]"       # #87ff00
    [LightGreen2]="\[\e[48;05;119m\]"       # #87ff5f
    [LightGreen]="\[\e[48;05;120m\]"        # #87ff87
    [PaleGreen2]="\[\e[48;05;121m\]"        # #87ffaf
    [Aquamarine1]="\[\e[48;05;122m\]"       # #87ffd7
    [DarkSlateGray1]="\[\e[48;05;123m\]"    # #87ffff
    [Red3]="\[\e[48;05;124m\]"              # #af0000
    [DeepPink6]="\[\e[48;05;125m\]"         # #af005f
    [MediumVioletRed]="\[\e[48;05;126m\]"   # #af0087
    [Magenta6]="\[\e[48;05;127m\]"          # #af00af
    [DarkViolet]="\[\e[48;05;128m\]"        # #af00d7
    [Purple1]="\[\e[48;05;129m\]"           # #af00ff
    [DarkOrange2]="\[\e[48;05;130m\]"       # #af5f00
    [IndianRed3]="\[\e[48;05;131m\]"        # #af5f5f
    [HotPink4]="\[\e[48;05;132m\]"          # #af5f87
    [MediumOrchid3]="\[\e[48;05;133m\]"     # #af5faf
    [MediumOrchid]="\[\e[48;05;134m\]"      # #af5fd7
    [MediumPurple3]="\[\e[48;05;135m\]"     # #af5fff
    [DarkGoldenrod]="\[\e[48;05;136m\]"     # #af8700
    [LightSalmon3]="\[\e[48;05;137m\]"      # #af875f
    [RosyBrown]="\[\e[48;05;138m\]"         # #af8787
    [Grey63]="\[\e[48;05;139m\]"            # #af87af
    [MediumPurple2]="\[\e[48;05;140m\]"     # #af87d7
    [MediumPurple1]="\[\e[48;05;141m\]"     # #af87ff
    [Gold3]="\[\e[48;05;142m\]"             # #afaf00
    [DarkKhaki]="\[\e[48;05;143m\]"         # #afaf5f
    [NavajoWhite3]="\[\e[48;05;144m\]"      # #afaf87
    [Grey69]="\[\e[48;05;145m\]"            # #afafaf
    [LightSteelBlue3]="\[\e[48;05;146m\]"   # #afafd7
    [LightSteelBlue]="\[\e[48;05;147m\]"    # #afafff
    [Yellow4]="\[\e[48;05;148m\]"           # #afd700
    [DarkOliveGreen4]="\[\e[48;05;149m\]"   # #afd75f
    [DarkSeaGreen5]="\[\e[48;05;150m\]"     # #afd787
    [DarkSeaGreen4]="\[\e[48;05;151m\]"     # #afd7af
    [LightCyan3]="\[\e[48;05;152m\]"        # #afd7d7
    [LightSkyBlue1]="\[\e[48;05;153m\]"     # #afd7ff
    [GreenYellow]="\[\e[48;05;154m\]"       # #afff00
    [DarkOliveGreen3]="\[\e[48;05;155m\]"   # #afff5f
    [PaleGreen1]="\[\e[48;05;156m\]"        # #afff87
    [DarkSeaGreen3]="\[\e[48;05;157m\]"     # #afffaf
    [DarkSeaGreen2]="\[\e[48;05;158m\]"     # #afffd7
    [PaleTurquoise1]="\[\e[48;05;159m\]"    # #afffff
    [Red2]="\[\e[48;05;160m\]"              # #d70000
    [DeepPink5]="\[\e[48;05;161m\]"         # #d7005f
    [DeepPink4]="\[\e[48;05;162m\]"         # #d70087
    [Magenta5]="\[\e[48;05;163m\]"          # #d700af
    [Magenta4]="\[\e[48;05;164m\]"          # #d700d7
    [Magenta3]="\[\e[48;05;165m\]"          # #d700ff
    [DarkOrange1]="\[\e[48;05;166m\]"       # #d75f00
    [IndianRed]="\[\e[48;05;167m\]"         # #d75f5f
    [HotPink3]="\[\e[48;05;168m\]"          # #d75f87
    [HotPink2]="\[\e[48;05;169m\]"          # #d75faf
    [Orchid]="\[\e[48;05;170m\]"            # #d75fd7
    [MediumOrchid2]="\[\e[48;05;171m\]"     # #d75fff
    [Orange1]="\[\e[48;05;172m\]"           # #d78700
    [LightSalmon2]="\[\e[48;05;173m\]"      # #d7875f
    [LightPink3]="\[\e[48;05;174m\]"        # #d78787
    [Pink3]="\[\e[48;05;175m\]"             # #d787af
    [Plum3]="\[\e[48;05;176m\]"             # #d787d7
    [Violet]="\[\e[48;05;177m\]"            # #d787ff
    [Gold2]="\[\e[48;05;178m\]"             # #d7af00
    [LightGoldenrod5]="\[\e[48;05;179m\]"   # #d7af5f
    [Tan]="\[\e[48;05;180m\]"               # #d7af87
    [MistyRose3]="\[\e[48;05;181m\]"        # #d7afaf
    [Thistle3]="\[\e[48;05;182m\]"          # #d7afd7
    [Plum2]="\[\e[48;05;183m\]"             # #d7afff
    [Yellow3]="\[\e[48;05;184m\]"           # #d7d700
    [Khaki3]="\[\e[48;05;185m\]"            # #d7d75f
    [LightGoldenrod4]="\[\e[48;05;186m\]"   # #d7d787
    [LightYellow3]="\[\e[48;05;187m\]"      # #d7d7af
    [Grey84]="\[\e[48;05;188m\]"            # #d7d7d7
    [LightSteelBlue1]="\[\e[48;05;189m\]"   # #d7d7ff
    [Yellow2]="\[\e[48;05;190m\]"           # #d7ff00
    [DarkOliveGreen2]="\[\e[48;05;191m\]"   # #d7ff5f
    [DarkOliveGreen1]="\[\e[48;05;192m\]"   # #d7ff87
    [DarkSeaGreen1]="\[\e[48;05;193m\]"     # #d7ffaf
    [Honeydew2]="\[\e[48;05;194m\]"         # #d7ffd7
    [LightCyan1]="\[\e[48;05;195m\]"        # #d7ffff
    [Red1]="\[\e[48;05;196m\]"              # #ff0000
    [DeepPink3]="\[\e[48;05;197m\]"         # #ff005f
    [DeepPink2]="\[\e[48;05;198m\]"         # #ff0087
    [DeepPink1]="\[\e[48;05;199m\]"         # #ff00af
    [Magenta2]="\[\e[48;05;200m\]"          # #ff00d7
    [Magenta1]="\[\e[48;05;201m\]"          # #ff00ff
    [OrangeRed1]="\[\e[48;05;202m\]"        # #ff5f00
    [IndianRed2]="\[\e[48;05;203m\]"        # #ff5f5f
    [IndianRed1]="\[\e[48;05;204m\]"        # #ff5f87
    [HotPink1]="\[\e[48;05;205m\]"          # #ff5faf
    [HotPink]="\[\e[48;05;206m\]"           # #ff5fd7
    [MediumOrchid1]="\[\e[48;05;207m\]"     # #ff5fff
    [DarkOrange]="\[\e[48;05;208m\]"        # #ff8700
    [Salmon1]="\[\e[48;05;209m\]"           # #ff875f
    [LightCoral]="\[\e[48;05;210m\]"        # #ff8787
    [PaleVioletRed1]="\[\e[48;05;211m\]"    # #ff87af
    [Orchid2]="\[\e[48;05;212m\]"           # #ff87d7
    [Orchid1]="\[\e[48;05;213m\]"           # #ff87ff
    [Orange]="\[\e[48;05;214m\]"            # #ffaf00
    [SandyBrown]="\[\e[48;05;215m\]"        # #ffaf5f
    [LightSalmon1]="\[\e[48;05;216m\]"      # #ffaf87
    [LightPink1]="\[\e[48;05;217m\]"        # #ffafaf
    [Pink1]="\[\e[48;05;218m\]"             # #ffafd7
    [Plum1]="\[\e[48;05;219m\]"             # #ffafff
    [Gold1]="\[\e[48;05;220m\]"             # #ffd700
    [LightGoldenrod3]="\[\e[48;05;221m\]"   # #ffd75f
    [LightGoldenrod2]="\[\e[48;05;222m\]"   # #ffd787
    [NavajoWhite1]="\[\e[48;05;223m\]"      # #ffd7af
    [MistyRose1]="\[\e[48;05;224m\]"        # #ffd7d7
    [Thistle1]="\[\e[48;05;225m\]"          # #ffd7ff
    [Yellow1]="\[\e[48;05;226m\]"           # #ffff00
    [LightGoldenrod1]="\[\e[48;05;227m\]"   # #ffff5f
    [Khaki1]="\[\e[48;05;228m\]"            # #ffff87
    [Wheat1]="\[\e[48;05;229m\]"            # #ffffaf
    [Cornsilk1]="\[\e[48;05;230m\]"         # #ffffd7
    [Grey100]="\[\e[48;05;231m\]"           # #ffffff
    [Grey3]="\[\e[48;05;232m\]"             # #080808
    [Grey7]="\[\e[48;05;233m\]"             # #121212
    [Grey11]="\[\e[48;05;234m\]"            # #1c1c1c
    [Grey15]="\[\e[48;05;235m\]"            # #262626
    [Grey19]="\[\e[48;05;236m\]"            # #303030
    [Grey23]="\[\e[48;05;237m\]"            # #3a3a3a
    [Grey27]="\[\e[48;05;238m\]"            # #444444
    [Grey30]="\[\e[48;05;239m\]"            # #4e4e4e
    [Grey35]="\[\e[48;05;240m\]"            # #585858
    [Grey39]="\[\e[48;05;241m\]"            # #626262
    [Grey42]="\[\e[48;05;242m\]"            # #6c6c6c
    [Grey46]="\[\e[48;05;243m\]"            # #767676
    [Grey50]="\[\e[48;05;244m\]"            # #808080
    [Grey54]="\[\e[48;05;245m\]"            # #8a8a8a
    [Grey58]="\[\e[48;05;246m\]"            # #949494
    [Grey62]="\[\e[48;05;247m\]"            # #9e9e9e
    [Grey66]="\[\e[48;05;248m\]"            # #a8a8a8
    [Grey70]="\[\e[48;05;249m\]"            # #b2b2b2
    [Grey74]="\[\e[48;05;250m\]"            # #bcbcbc
    [Grey78]="\[\e[48;05;251m\]"            # #c6c6c6
    [Grey82]="\[\e[48;05;252m\]"            # #d0d0d0
    [Grey85]="\[\e[48;05;253m\]"            # #dadada
    [Grey89]="\[\e[48;05;254m\]"            # #e4e4e4
    [Grey93]="\[\e[48;05;255m\]"            # #eeeeee
)

declare -A __BASH_PL_ATTRS=(
    [Reset]="\[\e[m\]"
    [Bold]="\[\e[1m\]"
    [Italic]="\[\e[3m\]"
    [Underline]="\[\e[4m\]"
    [Blink]="\[\e[5m\]"
    [Reverse]="\[\e[7m\]"
    [Hidden]="\[\e[8m\]"
)

declare -A __BASH_PL_SYMBOLS=(
    ##################
    # SYMBOL ENABLED
    ##################
    [line_separator]=""    # U+E0B1
    [fill_separator]=""    # U+E0B0

    # shell
    [error]=""             # U+F421
    [locked]=""            # U+E0A2
    [background]=""        # U+F110

    # Env
    [aws]=""               # U+F270
    [docker]=""            # U+E308
    [k8s]=""               # U+E91B
    [python]=""            # U+E235
    [terraform]=""         # U+E740

    # Git
    [octcat]=" "           # U+F408
    [git_staged]=""        # U+F440
    [git_modified]=""      # U+F448
    [git_untracked]=""     # U+F420
    [git_behind]=""        # U+F409
    [git_ahead]=""         # U+F40A
    [git_tag]=""           # U+F412
    [git_stash]=""         # U+F487
    [git_conflict]=""      # U+F46E
    [git_branch]=""        # U+F418
    [git_commit]=""        # U+F417
    [git_merge]=""         # U+F407
    [git_rebase]=""        # U+F419
    [git_patch]=""         # U+F47F
    [git_cherry]=""        # U+E29B
    [git_revert]=""        # U+F4A8
    [git_bisect]=""        # U+F402

    # Host
    [win]=""               # U+E70F
    [ubuntu]=""            # U+F31C
    [redhat]=""            # U+F316
    [centos]=""            # U+F304

    # Common
    [user]=""              # U+F415
    [home]=""              # U+F46D
    [dir]=""               # U+F413
    [time]=""              # U+F43A
    [tls]=""               # U+F43D


    ##################
    # SYMBOL DISABLED
    ##################
    [line_separator_alt]="|"
    [fill_separator_alt]=""

    # shell
    [error_alt]="ErrorCode:"
    [locked_alt]="ReadOnly"
    [background_alt]="Jobs:"

    # Env
    [aws_alt]="(AWS)"
    [docker_alt]="(Docker)"
    [k8s_alt]="(k8s)"
    [python_alt]="(Python venv)"
    [terraform_alt]="(Terraform)"

    # Git
    [octcat_alt]="(Git)"
    [git_staged_alt]="+"
    [git_modified_alt]="*"
    [git_untracked_alt]="?"
    [git_behind_alt]="<"
    [git_ahead_alt]=">"
    [git_tag_alt]="Tags:"
    [git_stash_alt]="$"
    [git_conflict_alt]="!"
    [git_branch_alt]=""
    [git_commit_alt]=""
    [git_merge_alt]=""
    [git_rebase_alt]=""
    [git_patch_alt]=""
    [git_cherry_alt]=""
    [git_revert_alt]=""
    [git_bisect_alt]=""

    # Host
    [win_alt]="(Windows)"
    [ubuntu_alt]="(Ubuntu)"
    [redhat_alt]="(RHEL)"
    [centos_alt]="(CentOS)"

    # Common
    [user_alt]=""
    [home_alt]=""
    [dir_alt]=""
    [time_alt]=""
    [tls_alt]="(TLS)"
)



################################################################################
# FUNCTIONS
################################################################################

function __setup() {
    __return_code__=$?

    __number_bgjobs__=$(jobs -p | wc -l)

    __module_color__=""
    __module_attrs__=""
    __prev_bg_color__=""

    __ps1_buffer__=""

    # Global Vars
    export __BASH_PL_PREV_DIRS
    export __BASH_PL_OLDPWD
    export __BASH_PL_DIR_FORMAT_OLD
    export __BASH_PL_DIR_FORMAT=${__BASH_PL_DIR_FORMAT:-"full"} # or short,dironly
    export __BASH_PL_WRAP_COLUMN=${__BASH_PL_WRAP_COLUMN:-100}
    export __BASH_PL_GIT_NEWLINE=${__BASH_PL_GIT_NEWLINE:-true}

    # Flags
    export __BASH_PL_AWS_DISABLE
    export __BASH_PL_DOCKER_DISABLE
    export __BASH_PL_GIT_DISABLE
    export __BASH_PL_PYTHON_DISABLE
    export __BASH_PL_K8S_DISABLE
    export __BASH_PL_SYMBOL_DISABLE
    export __BASH_PL_TERRAFORM_DISABLE

    # For performance (DO NOT TOUCH)
    export __BASH_PL_K8S_CONTEXT
    export __BASH_PL_K8S_CLUSTER
    export __BASH_PL_K8S_NAMESPACE

    PS1=""
}


function __teardown() {
    __update_color_of
    __flush_line

    PS1+=" "

    unset \
        __return_code__ \
        __number_bgjobs__ \
        __ps1_buffer__ \
        __module_color__ \
        __module_attrs__ \
        __prev_bg_color__ \
        __is_git_dir__
}


function __append_prompt() {
    local _add_prompt=${1}
    local _callee_module=${FUNCNAME[1]//__module_/}

    __update_color_of ${_callee_module}

    if [[ -n ${__ps1_buffer__} ]]; then
        __ps1_buffer__+="${__separator_color__}${__BASH_PL_SYMBOLS[fill_separator${__BASH_PL_SYMBOL_DISABLE:+_alt}]}${__BASH_PL_ATTRS[Reset]}"
    fi

    __ps1_buffer__+="${__module_color__} ${_add_prompt} "
}


function __flush_line() {
    PS1+="${__ps1_buffer__}${__separator_color__}${__BASH_PL_SYMBOLS[fill_separator${__BASH_PL_SYMBOL_DISABLE:+_alt}]}${__BASH_PL_ATTRS[Reset]}"

    __separator_color__=""
    __ps1_buffer__=""
}


function __parse_attributes() {
    local _module_attrs=$1

    __module_attrs__=${__BASH_PL_ATTRS[Reset]}

    while IFS= read -d ';' attr; do
        __module_attrs__+=${__BASH_PL_ATTRS[${attr}]}
    done <<<${_module_attrs}";"
}


function __update_color_of() {
    local _module_name=${1:-newline}

    test -z "${PS1}" && return 0

    local _fg_color
    local _bg_color
    local _attrs

    IFS=$";" read _fg_color _bg_color _attrs <<<${__BASH_PL_MODULE_COLORS[${_module_name}]}
    test ! -z ${_attrs} && __parse_attributes ${_attrs}

    if [[ ! -z ${__ps1_buffer__} ]]; then
        __separator_color__="${__BASH_PL_ATTRS[Reset]}${__BASH_PL_FG_COLORS[${__prev_bg_color__}]}${__BASH_PL_BG_COLORS[${_bg_color}]}"
    fi

    __module_color__="${__module_attrs__}${__BASH_PL_FG_COLORS[${_fg_color}]}${__BASH_PL_BG_COLORS[${_bg_color}]}"
    __prev_bg_color__=${_bg_color}
}



# ==============================================================================
# Modules
# ==============================================================================

# --------------
# newline module
# --------------
function __module_newline() {
    if [[ ! -z ${__ps1_buffer__} ]]; then
        __update_color_of newline
        __flush_line
    fi

    PS1+="\n"
}


# --------------
# AWS-profile module
# --------------
function __module_aws() {
    [[ -z ${__BASH_PL_AWS_DISABLE} ]] || return 0
    [[ -z ${AWS_PROFILE} || ${AWS_PROFILE} = "default" ]] && return 0

    __append_prompt "${__BASH_PL_SYMBOLS[aws${__BASH_PL_SYMBOL_DISABLE:+_alt}]}${AWS_PROFILE}"
}


# --------------
# Background jobs module
# --------------
function __module_bgjobs() {
    [[ ${__number_bgjobs__} -eq 0 ]] && return 0

    __append_prompt "${__BASH_PL_SYMBOLS[background${__BASH_PL_SYMBOL_DISABLE:+_alt}]}${__number_bgjobs__}"
}


# --------------
# CWD module
# --------------
function __module_cwd() {
    local _tmp_ps1

    if [[ ${PWD} != ${__BASH_PL_OLDPWD} ]]; then
        local _pwd_dirs
        local _pwd=${PWD//*?(Users|home)\/${USER}/\~}
        _pwd=${_pwd// /___}

        test ${_pwd:0:1} = "~" \
            && _tmp_ps1="${__BASH_PL_SYMBOLS[home${__BASH_PL_SYMBOL_DISABLE:+_alt}]}" \
            || _tmp_ps1="${__BASH_PL_SYMBOLS[dir${__BASH_PL_SYMBOL_DISABLE:+_alt}]}"

        if   [[ ${__BASH_PL_DIR_FORMAT} = "dironly" ]]; then
            _tmp_ps1+=${_pwd##*/}
        elif [[ ${__BASH_PL_DIR_FORMAT} = "short"   ]]; then
            _tmp_ps1+=${_pwd}
        else
            IFS=$'/' read -a _pwd_dirs <<<${_pwd#/}

            if   [[ ${#_pwd_dirs[@]} -gt 5 ]]; then
                _tmp_ps1+="${_pwd_dirs[0]} ${__BASH_PL_SYMBOLS[line_separator${__BASH_PL_SYMBOL_DISABLE:+_alt}]//|//} "
                _tmp_ps1+="${_pwd_dirs[1]} ${__BASH_PL_SYMBOLS[line_separator${__BASH_PL_SYMBOL_DISABLE:+_alt}]//|//} ..."
                _pwd_dirs=("${_pwd_dirs[@]:${#_pwd_dirs[@]}-3}")
            elif [[ ${_pwd_dirs[0]} = "~" ]]; then
                _tmp_ps1+="~"
                _pwd_dirs=("${_pwd_dirs[@]:1}")
            else
                _tmp_ps1+=${_pwd_dirs[0]:-/}
                _pwd_dirs=("${_pwd_dirs[@]:1}")
            fi

            for dir in ${_pwd_dirs[@]}; do
                _tmp_ps1+=" ${__BASH_PL_SYMBOLS[line_separator${__BASH_PL_SYMBOL_DISABLE:+_alt}]//|//} ${dir//___/ }"
            done
        fi

        __BASH_PL_PREV_DIRS="${_tmp_ps1}"
        __BASH_PL_OLDPWD=${PWD}
    else
        _tmp_ps1=${__BASH_PL_PREV_DIRS}
    fi

    __append_prompt "${_tmp_ps1}"
}


# --------------
# Docker module
# --------------
function __module_docker() {
    [[ -z ${__BASH_PL_DOCKER_DISABLE} ]] || return 0
    [[ -z ${DOCKER_HOST} ]] && return 0

    local _docker_addr=${DOCKER_HOST#*://}
    local _tls_verify="${DOCKER_TLS_VERIFY:+${__BASH_PL_SYMBOLS[tls${__BASH_PL_SYMBOL_DISABLE:+_alt}]}}"
    local _docker_machine_name="${DOCKER_MACHINE_NAME:+(${DOCKER_MACHINE_NAME})}"

    __append_prompt "${__BASH_PL_SYMBOLS[docker${__BASH_PL_SYMBOL_DISABLE:+_alt}]}${_tls_verify}${_docker_addr}${_docker_machine_name}"
}


# --------------
# Prompt module
# --------------
function __module_prompt() {
    __append_prompt "\\$"
}


# --------------
# Error code module
# --------------
function __module_error() {
    [[ ${__return_code__} -eq 0 ]] && return 0

    __append_prompt "${__BASH_PL_SYMBOLS[error${__BASH_PL_SYMBOL_DISABLE:+_alt}]}${__return_code__}"
}


# --------------
# Git module
# --------------
function __module_git() {
    [[ -z ${__BASH_PL_GIT_DISABLE} ]] || return 0

    local _git_dir
    local _inside_git_dir
    local _inside_work_tree
    local _hash

    read -d '\n' _git_dir _inside_git_dir _inside_work_tree _hash \
        <<<$(git rev-parse --git-dir --is-inside-git-dir --is-inside-work-tree --short HEAD 2>/dev/null)

    if [[ ${_inside_git_dir} = "true" || ${_inside_work_tree} != "true" ]]; then
        return 0
    fi

    local _separator="${__BASH_PL_FG_COLORS[White]} ${__BASH_PL_SYMBOLS[line_separator${__BASH_PL_SYMBOL_DISABLE:+_alt}]} "

    # Get info in background
    git ls-files --others --exclude-standard --directory --no-empty-directory --error-unmatch -- ':/*' >/dev/null 2>&1 &
    local _untracked_pid=$!

    git diff --no-ext-diff --ignore-submodules --quiet &
    local _modified_pid=$!

    git ls-files -u --error-unmatch -- ':/*' >/dev/null 2>&1 &
    local _conflict_pid=$!

    git diff --no-ext-diff --ignore-submodules --cached --quiet &>/dev/null &
    local _staged_pid=$!

    git rev-parse --verify refs/stash &>/dev/null &
    local _stash_pid=$!

    # Check for untracked, unstaged(modified), uncommitted, stashed files.
    local _flags=""
    wait ${_untracked_pid}; test $? -eq 0 && _flags+="${__BASH_PL_FG_COLORS[Grey35]}${__BASH_PL_SYMBOLS[git_untracked${__BASH_PL_SYMBOL_DISABLE:+_alt}]}"
    wait ${_modified_pid};  test $? -ne 0 && _flags+="${__BASH_PL_FG_COLORS[Maroon]}${__BASH_PL_SYMBOLS[git_modified${__BASH_PL_SYMBOL_DISABLE:+_alt}]}"
    wait ${_conflict_pid};  test $? -eq 0 && _flags+="${__BASH_PL_FG_COLORS[Yellow]}${__BASH_PL_SYMBOLS[git_conflict${__BASH_PL_SYMBOL_DISABLE:+_alt}]}"
    wait ${_staged_pid};    test $? -ne 0 && _flags+="${__BASH_PL_FG_COLORS[Green]}${__BASH_PL_SYMBOLS[git_staged${__BASH_PL_SYMBOL_DISABLE:+_alt}]}"
    wait ${_stash_pid};     test $? -eq 0 && _flags+="${__BASH_PL_FG_COLORS[Navy]}${__BASH_PL_SYMBOLS[git_stash${__BASH_PL_SYMBOL_DISABLE:+_alt}]}"
    _flags=${_flags:+${_separator}${_flags}}

    # Check rebase
    local _rebase
    local _step
    local _total
    local _head
    if   [[ -d ${_git_dir}/rebase-merge ]]; then
            read _step _total _head \
                <<<"$(< ${_git_dir}/rebase-merge/msgnum) $(< ${_git_dir}/rebase-merge/end) $(< ${_git_dir}/rebase-merge/head-name)"

            if [[ -f ${_git_dir}/rebase-merge/interactive ]]; then
                _rebase+="${__BASH_PL_SYMBOLS[git_rebase${__BASH_PL_SYMBOL_DISABLE:+_alt}]}REBASING(interactive)"
            else
                _rebase+="${__BASH_PL_SYMBOLS[git_rebase${__BASH_PL_SYMBOL_DISABLE:+_alt}]}REBASING(merge)"
            fi
    else
        if [[ -d ${_git_dir}/rebase-apply ]]; then
            read _step _total _head \
                <<<"$(< ${_git_dir}/rebase-apply/next) $(< ${_git_dir}/rebase-apply/last) $(< ${_git_dir}/rebase-apply/head-name)"

            if   [[ -f ${_git_dir}/rebase-apply/rebasing ]]; then
                _rebase+="${__BASH_PL_SYMBOLS[git_rebase${__BASH_PL_SYMBOL_DISABLE:+_alt}]}REBASING"
            elif [[ -f ${_git_dir}/rebase-apply/applying ]]; then
                _rebase+="${__BASH_PL_SYMBOLS[git_patch${__BASH_PL_SYMBOL_DISABLE:+_alt}]}Applying Mailbox"
            else
                _rebase+="${__BASH_PL_SYMBOLS[git_rebase${__BASH_PL_SYMBOL_DISABLE:+_alt}]}AM/REBASING"
            fi
        elif [[ -f ${_git_dir}/MERGE_HEAD ]]; then
            _rebase+="${__BASH_PL_SYMBOLS[git_merge${__BASH_PL_SYMBOL_DISABLE:+_alt}]}MERGING"
        elif [[ -f ${_git_dir}/CHERRY_PICK_HEAD ]]; then
            _rebase+="${__BASH_PL_SYMBOLS[git_cherry${__BASH_PL_SYMBOL_DISABLE:+_alt}]}CHERRY-PICKING"
        elif [[ -f ${_git_dir}/REVERT_HEAD ]]; then
            _rebase+="${__BASH_PL_SYMBOLS[git_revert${__BASH_PL_SYMBOL_DISABLE:+_alt}]}REVERTING"
        elif [[ -f ${_git_dir}/BISECT_LOG ]]; then
            _rebase+="${__BASH_PL_SYMBOLS[git_bisect${__BASH_PL_SYMBOL_DISABLE:+_alt}]}BISECTING"
        else
            # Check tag at this commit.
            local _tags=$(git tag --points-at HEAD --column=always 2>/dev/null)
            _tags="${_tags:+${_separator}${__BASH_PL_FG_COLORS[Olive]}${__BASH_PL_SYMBOLS[git_tag${__BASH_PL_SYMBOL_DISABLE:+_alt}]}${_tags//+([[:space:]])/,}}"
        fi

        local _branch=${_head#refs/heads/}
        _branch=${_branch:-$( \
            git symbolic-ref --quiet --short HEAD 2> /dev/null \
                || git rev-parse --short HEAD 2> /dev/null \
                || echo 'UNNAMED')}
        _branch="${__BASH_PL_FG_COLORS[Purple]}${__BASH_PL_SYMBOLS[git_branch${__BASH_PL_SYMBOL_DISABLE:+_alt}]}${_branch}"
        _branch+="${_hash:+${__BASH_PL_FG_COLORS[White]}(${__BASH_PL_FG_COLORS[Lime]}${__BASH_PL_SYMBOLS[git_commit${__BASH_PL_SYMBOL_DISABLE:+_alt}]}${_hash}${__BASH_PL_FG_COLORS[White]})}"
    fi

    if [[ -n ${_step} && -n ${_total} ]]; then
        _rebase+=" ${_step}/${_total}"
    fi
    _rebase="${_rebase:+${_separator}${_rebase}}"

    # Ahead/Behind against remote
    local _ahead
    local _behind
    local _remote_diff
    read _behind _ahead <<<$(git rev-list --count --left-right '@{upstream}...HEAD' 2>/dev/null)

    if [[ $? -eq 0 ]]; then
        if [[ ${_behind} -ne 0 ]]; then
            _remote_diff+="${__BASH_PL_SYMBOLS[git_behind${__BASH_PL_SYMBOL_DISABLE:+_alt}]}${_behind}"
        fi

        if [[ ${_ahead} -ne 0 ]]; then
            _remote_diff+="${_remote_diff:+ }${__BASH_PL_SYMBOLS[git_ahead${__BASH_PL_SYMBOL_DISABLE:+_alt}]}${_ahead}"
        fi
    fi
    _remote_diff=${_remote_diff:+${_separator}${_remote_diff}}

    _tmp_ps1="${_branch}${_tags}${_flags}${_remote_diff}${_rebase}"
    __append_prompt "${__BASH_PL_SYMBOLS[octcat${__BASH_PL_SYMBOL_DISABLE:+_alt}]}${_tmp_ps1}"
    test "${__BASH_PL_GIT_NEWLINE,,}" = "true" && __module_newline
}


# --------------
# k8s module
# --------------
function __module_k8s() {
    [[ -z ${__BASH_PL_K8S_DISABLE} ]] || return 0
    [[ -z ${__BASH_PL_K8S_CONTEXT} || ${__BASH_PL_K8S_CONTEXT} = "default" ]] && return 0

    __append_prompt "${__BASH_PL_SYMBOLS[k8s${__BASH_PL_SYMBOL_DISABLE:+_alt}]}${__BASH_PL_K8S_CONTEXT}${__BASH_PL_K8S_NAMESPACE:+ ${__BASH_PL_SYMBOLS[line_separator${__BASH_PL_SYMBOL_DISABLE:+_alt}]} ${__BASH_PL_K8S_NAMESPACE}}${__BASH_PL_K8S_CLUSTER:+ ${__BASH_PL_SYMBOLS[line_separator${__BASH_PL_SYMBOL_DISABLE:+_alt}]} ${__BASH_PL_K8S_CLUSTER}}"
}


# --------------
# Host module
# --------------
function __module_host() {
    local _dist=""

    if   [[ -f /etc/redhat-release ]]; then
        _dist=$(awk '{print $1}' /etc/redhat-release)
        _dist=${_dist/Red/RedHat}
    elif [[ -f /etc/lsb-release    ]]; then
        _dist=$(sed -n '1 s/.*=//p' /etc/lsb-release)
    else
        _dist="win"
    fi

    __append_prompt "${__BASH_PL_SYMBOLS[${_dist,,}${__BASH_PL_SYMBOL_DISABLE:+_alt}]}\h"
}


# --------------
# ReadOnly dir module
# --------------
function __module_rodir() {
    [[ -w ${PWD} ]] && return 0

    __append_prompt "${__BASH_PL_SYMBOLS[locked${__BASH_PL_SYMBOL_DISABLE:+_alt}]}"
}


# --------------
# Python VENV module
# --------------
function __module_python() {
    [[ -z ${__BASH_PL_PYTHON_DISABLE} ]] || return 0
    [[ -z ${VIRTUAL_ENV} ]] && return 0

    __append_prompt "${__BASH_PL_SYMBOLS[python${__BASH_PL_SYMBOL_DISABLE:+_alt}]}${VIRTUAL_ENV##*/}"
}


# --------------
# Terraform module
# --------------
function __module_terraform() {
    [[ -z ${__BASH_PL_TERRAFORM_DISABLE} ]] || return 0
    [[ -d ./.terraform ]] || return 0

    __append_prompt "${__BASH_PL_SYMBOLS[terraform${__BASH_PL_SYMBOL_DISABLE:+_alt}]}$(test -f ./.terraform/environment && cat ./.terraform/environment || echo default)"
}


# --------------
# Time module
# --------------
function __module_time() {
    __append_prompt "${__BASH_PL_SYMBOLS[time${__BASH_PL_SYMBOL_DISABLE:+_alt}]}\t"
}


# --------------
# User module
# --------------
function __module_user() {
    if [[ $(id -u) -eq 0 ]]; then
        __BASH_PL_MODULE_COLORS[user]="Maroon;Grey23;Bold"
    fi

    __append_prompt "${__BASH_PL_SYMBOLS[user${__BASH_PL_SYMBOL_DISABLE:+_alt}]}\u"
}


################################################################################

function aws-profile() {
    local profile_name=${1}

    test -z "${profile_name}" && { export AWS_PROFILE=""; return 0; }
    grep -q ${profile_name} ${HOME}/.aws/config &>/dev/null || return 0

    export AWS_PROFILE=${profile_name}
}


function pl-dir-format() {
    case "${1,,}" in
    "full" | "short" | "dironly")
        __BASH_PL_DIR_FORMAT=${1,,}
        ;;
    *)
        cat <<__MSG__
Invalid argument.

Usage:
    pl-dir-format (full|short|dironly)

    NOTE: The arguments treats "case-insensitive".
__MSG__
        ;;
    esac

    __BASH_PL_OLDPWD=""
}


function pl-enable() {
    unset eval "__BASH_PL_${1^^}_DISABLE"

    if [[ ${1,,} = "symbol" ]]; then
        __BASH_PL_OLDPWD=""
    fi
}


function pl-disable() {
    printf -v "__BASH_PL_${1^^}_DISABLE" "%s" "true"

    if [[ ${1,,} = "symbol" ]]; then
        __BASH_PL_OLDPWD=""
    fi
}


function kube-context() {
    local _tmp_mark
    local _tmp_auth

    kubectl config use-context ${1}
    read _tmp_mark __BASH_PL_K8S_CONTEXT __BASH_PL_K8S_CLUSTER _tmp_auth __BASH_PL_K8S_NAMESPACE <<<$(kubectl config get-contexts | sed -n '/^\*/ p')
}


################################################################################

# Entrypoint
function __bash_powerline() {
    __setup

    for _module_prefix in ${__BASH_PL_MODULES[@]}; do
        __module_${_module_prefix}
    done

    __teardown
}


export PROMPT_COMMAND="__bash_powerline"
