module Quest exposing (Quest, list, mocks)

import Element exposing (Element)
import Material.List as List
import Theme exposing (Theme)


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
    [ Quest "PBR introduction" "A short introduction to PBR" "Texturing" "4 min" "more info"
    , Quest "PBR basics" "The basics of PBR usage is explained here" "Texturing" "10 min" "more info"
    ]


list : Theme -> List Quest -> Element msg
list theme quests =
    List.threeLine theme <| List.map toItem quests


toItem : Quest -> List.Item
toItem quest =
    { first = quest.title
    , second = quest.description
    , url = Nothing
    }
