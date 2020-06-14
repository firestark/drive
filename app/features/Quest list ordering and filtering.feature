Feature: Quest list ordering and filtering
    In order to find quests that are relevant for me
    As an art director
    I need to be able to filter quests


    Background:
        Given the following quests exist:
            | Title         | Description                                                           | Category    | Time estimate | Creation date |
            | PBR basics    | This tutorial will explain what PBR shading is.                       | Texturing   | 5 - 10        | 6 June 2020   |
            | Unreal basics | This tutorial will explain the basics of the unreal engine workspace. | Game engine | 5 - 10        | 5 June 2020   |


    Scenario: Default ordering
        Given the art director has not requested for a specific ordering
        When the art director opens the quest list
        Then The quests are ordered by creation date in descending order


    Scenario: Ordering by Category
        Given the art director has not requested for a specific ordering
        When the art director orders the quest list by category
        Then the quests are ordered by category by alphabetical order


    Scenario: Filtering by category
        Given the art director has not filtered the quest list
        When the art director filters for category with the text "Game"
        Then the results contain quests with a category containing the text "Game"


    Scenario: Filtering by text
        Given the art director has not filtered the quest list
        When the art director filters with text "PBR"
        Then the results contain quests with a title or description containing the text "PBR"


    Scenario: Filtering by time estimate
        Given the art director has not filtered the quest list
        When the art director filters for quest with a time estimate of 5 - 10 minutes
        Then the results contain quests with a time estimate of 5 - 10 minutes
