module Quest exposing (Quest, mocks)


type alias Quest =
    { title : String
    , description : String
    , category : String
    , timeEstimate : String
    , moreInfo : String
    }


mocks : List ( String, List Quest )
mocks =
    [ ( "Texturing", texturingList )
    ]


texturingList : List Quest
texturingList =
    [ Quest "PBR introduction" "A short introduction to PBR" "Texturing" "4 min" "PBR is a new improved workflow for texturing. Get to know PBR with this tutorial: https://www.youtube.com/watch?v=7NjGETJMZvY&t=85s"
    , Quest "PBR basics" "The basics of PBR usage is explained here" "Texturing" "10 min" "PBR is a new improved workflow for texturing. Get to know PBR with this tutorial: https://www.youtube.com/watch?v=_LaVvGlkBDs"
    ]
