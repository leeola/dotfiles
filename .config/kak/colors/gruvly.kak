# code

evaluate-commands %{
  # dark0           = 282828
  # dark1           = 3c3836
  # dark2           = 504945
  # dark3           = 665c54
  # dark4           = 7c6f64
  #
  # bright red      = fb4934
  # bright green    = b8bb26
  # bright yellow   = fabd2f
  # bright blue     = 83a598
  # bright purple   = d3869b
  # bright aqua     = 8ec07c
  # bright orange   = fe8019
  #
  # neutral red     = cc241d
  # neutral green   = 98971a
  # neutral yellow  = d79921
  # neutral blue    = 458588
  # neutral purple  = b16286
  # neutral aqua    = 689d6a
  # neutral orange  = d65d0e
  #
  # faded red       = 9d0006
  # faded green     = 79740e
  # faded yellow    = b57614
  # faded blue      = 076678
  # faded purple    = 8f3f71
  # faded aqua      = 427b58
  # faded orange    = af3a03

  face global value rgb:b16286,default
  face global type rgb:fe8019,default
  face global identifier rgb:cd231d,default
  face global string rgb:689d68,default
  face global error default,rgb:ffffff
  face global keyword rgb:fb4934,default
  face global operator rgb:dedede,default
  face global attribute rgb:458588,default
  face global comment rgb:928374,default
  face global meta rgb:878787,default
  face global builtin rgb:d65d03,default

  # text

  face global title rgb:689c6a,default+b
  face global header rgb:ffffff,default
  face global bold rgb:ffffff,default+b
  face global italic rgb:ededed,default+i
  face global mono rgb:cccccc,rgb:212121
  face global block rgb:cccccc,rgb:212121
  face global link rgb:ffffff,default
  face global bullet rgb:ffffff,default
  face global list rgb:dedede,default

  # kakoune UI

  face global Default rgb:ebdbb2,rgb:292929
  face global PrimarySelection rgb:292929,rgb:689c6a
  face global SecondarySelection rgb:292929,rgb:689c6a
  face global PrimaryCursor rgb:292929,rgb:ebdbb2+b
  face global SecondaryCursor rgb:292929,rgb:918273+b
  face global MatchingChar default,rgb:333333
  face global Search default,rgb:333333
  face global Whitespace default,rgb:333333
  face global BufferPadding rgb:333333,default
  face global LineNumbers rgb:655b53,default
  face global LineNumberCursor rgb:fabd2f,default
  face global MenuForeground rgb:121212,rgb:918273
  face global MenuBackground default,rgb:212121
  face global MenuInfo default,rgb:4f4945
  face global Information default,rgb:454545
  face global Error rgb:121212,rgb:dedede
  face global StatusLine rgb:689c6a,rgb:292929
  face global StatusLineMode rgb:ebdbb2,rgb:292929
  face global StatusLineInfo rgb:8ec07c,rgb:292929
  face global StatusLineValue rgb:689c6a,rgb:292929
  face global StatusCursor rgb:292929,rgb:655b53
  face global Prompt rgb:7d6f64,rgb:ebdbb2
}
