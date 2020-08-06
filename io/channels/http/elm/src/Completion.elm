module Completion exposing (Completion, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)


type alias Completion =
    { title : String
    , completedAt : Int
    }


decoder : Decoder (List Completion)
decoder =
    Decode.list
        itemDecoder


itemDecoder : Decoder Completion
itemDecoder =
    Decode.succeed Completion
        |> required "title" Decode.string
        |> required "completedAt" Decode.int
