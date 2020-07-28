module Quest exposing (Quest, decoder)

import Json.Decode as Decode exposing (Decoder, string, succeed)
import Json.Decode.Pipeline exposing (required)


type alias Quest =
    { title : String
    , description : String
    , category : String
    , timeEstimate : String
    , moreInfo : String
    }


decoder : Decoder (List Quest)
decoder =
    Decode.list
        itemDecoder


itemDecoder : Decoder Quest
itemDecoder =
    Decode.succeed Quest
        |> required "title" string
        |> required "description" string
        |> required "category" string
        |> required "timeEstimate" string
        |> required "moreInfo" string
