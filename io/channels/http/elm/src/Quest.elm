module Quest exposing (Quest, mocks)


type alias Quest =
    { title : String
    , description : String
    , category : String
    , timeEstimate : String
    , moreInfo : String
    }


mocks : List Quest
mocks =
    [ Quest "PBR introduction" "A short introduction to PBR" "Texturing" "4 min" "PBR is a new improved workflow for texturing. Get to know PBR with this tutorial: https://www.youtube.com/watch?v=7NjGETJMZvY&t=85s"
    , Quest "PBR basics" "The basics of PBR usage is explained here" "Texturing" "10 min" "PBR is a new improved workflow for texturing. Get to know PBR with this tutorial: https://www.youtube.com/watch?v=_LaVvGlkBDs"
    , Quest "Game genres explained" "Every game genre has it charms, learn about them here" "Idea exploration" "5 - 10 min" "Every game genre has it charms, learn about them here"
    ]
