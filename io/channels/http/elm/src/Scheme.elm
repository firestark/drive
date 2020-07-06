module Scheme exposing (Session, Scheme, add, groupSchemes, list, mock, mocks, remove, toDateString)

import Date exposing (Date)
import Element exposing (Element)
import Exercise exposing (Exercise)
import Material.List as List
import Route
import Theme exposing (Theme)
import Time exposing (Month(..))

type alias Completion = (Exercise, List Int)

type alias Session = 
    { date : Date
    , completions : List Completion
    }

type alias Scheme =
    { id : String
    , name : String
    , createdAt : Date
    , sessions : List (Int, Session)
    , exercises : List (Int, Exercise)
    }

remove : Int -> List (Int, Session) -> List (Int, Session)
remove id sessions =
    List.filter (not << isId id) sessions


isId : Int -> (Int, Session) -> Bool
isId find (inList, _) =
    find == inList


list : Theme -> List Scheme -> Element msg
list theme schemes =
    List.singleLine theme <| List.map toItem schemes


toItem : Scheme -> List.Item
toItem scheme =
    { first = scheme.name
    , second = ""
    , url = Just <| Route.routeToString (Route.Scheme scheme.id)
    }

toDateString : Date -> String
toDateString date =
    Date.format "MMMM y" date

add : Session -> List (Int, Session) -> List (Int, Session)
add session sessions =
    let maybeLast = List.head <| List.reverse sessions
        id = case maybeLast of
            Nothing -> 1
            Just (i, _) -> i
    in
        (id, session) :: sessions

groupSchemes : List Scheme -> List (Date, List Scheme)
groupSchemes schemes =
    List.map group1Set <| groupWhile sameSchemeMonth schemes

group1Set : (Scheme, List Scheme) -> (Date, List Scheme)
group1Set set =
    let date = .createdAt (Tuple.first set)
        schemes = Tuple.first set :: Tuple.second set
    in
        (date, schemes)

groupWhile : (a -> a -> Bool) -> List a -> List (a, List a)
groupWhile isSameGroup items =
    List.foldr
        (\x acc ->
            case acc of
                [] ->
                    [ (x, []) ]

                (y, restOfGroup) :: groups ->
                    if isSameGroup x y then
                        (x, y :: restOfGroup) :: groups

                    else
                        (x, []) :: acc
        )
        []
        items

sameSchemeMonth : Scheme -> Scheme -> Bool
sameSchemeMonth a b =
    sameMonth a.createdAt b.createdAt

sameMonth : Date -> Date -> Bool
sameMonth date testDate =
    let beginMonth = Date.floor Date.Month date
        endMonth = Date.ceiling Date.Month date
    in
        Date.isBetween beginMonth endMonth testDate


------------------------------------------------------------------------------------
-- Mocks
------------------------------------------------------------------------------------

schemeDate1 : Date
schemeDate1 =
    Date.fromPosix
        Time.utc
        (Time.millisToPosix (1583681692 * 1000))

schemeDate2 : Date
schemeDate2 =
    Date.fromPosix
        Time.utc
        (Time.millisToPosix (1579651200 * 1000))

schemeDate3 : Date
schemeDate3 =
    Date.fromPosix
        Time.utc
        (Time.millisToPosix (1581379200 * 1000))

mocks : List Scheme
mocks =
    [ Scheme "1" "Chest" schemeDate1 [ (1, { date = schemeDate1, completions = [] }), (2, { date = schemeDate2, completions = [] }) ] 
        [ (1, Exercise "Bench press" 4 8), (2, Exercise "Dumbbell press" 3 10), (3, Exercise "Dumbbell flyes" 3 10) ]
    , Scheme "2" "Back" schemeDate1 [ (1, { date = schemeDate1, completions = [] }) ] [ (1, Exercise "Deadlift" 4 8), (2, Exercise "Cable rows" 3 10) ]
    , Scheme "3" "Legs" schemeDate1 [ (1, { date = schemeDate1, completions = [] }) ] []
    , Scheme "4" "Shoulders" schemeDate1 [ (1, { date = schemeDate1, completions = [] }) ] []
    , Scheme "5" "Chest" schemeDate2 [ (1, { date = schemeDate1, completions = [] }) ] []
    , Scheme "6" "Back" schemeDate2 [ (1, { date = schemeDate1, completions = [] }) ] []
    , Scheme "7" "Legs" schemeDate2 [ (1, { date = schemeDate1, completions = [] }) ] []
    , Scheme "8" "Chest" schemeDate3 [ (1, { date = schemeDate1, completions = [] }) ] []
    , Scheme "9" "Back" schemeDate3 [ (1, { date = schemeDate1, completions = [] }) ] []
    , Scheme "10" "Legs" schemeDate3 [ (1, { date = schemeDate1, completions = [] }) ] []
    , Scheme "11" "Shoulders" schemeDate3 [ (1, { date = schemeDate1, completions = [] }) ] []
    ]

mock : String -> Scheme
mock id =
    let scheme = List.head <| List.filter (\s -> s.id == id) mocks
        in case scheme of
            Just trueModel -> trueModel
            Nothing -> Scheme "1" "Chest" schemeDate1 [ (1, { date = schemeDate1, completions = [] }) ] []