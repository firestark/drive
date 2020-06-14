Feature: Quest achievements
    In order to see who has what kind of knowledge,
        see what quests to do next,
        recommend good quests to other art directors
        and be motivated by my quest progress
    As an art director
    I need to be able to see what quests are done and by whom they are done


    Background:
        Given an art director called "Aron" exists
        And an art director called "Glenn" exists
        And the following quests exist:
            | Title         | Category    |
            | PBR basics    | Texturing   |
            | Unreal basics | Game engine |

        And given "Aron" has completed the quest with a title of "Unreal engine basics"


    Scenario: Completing a quest
        When "Aron" completes the quest with the title of "PBR basics"
        Then "Aron" should see he has completed the quest with the title of "PBR basics"
        And "Aron" should have a quest with a title of "PBR basics"
            and a completion date of today in his completed quests list


    Scenario: Uncomplete a quest
        When "Aron" uncompletes the quest with the title of "Unreal engine basics"
        Then "Aron" should see he has uncompleted the quest with the title of "Unreal engine basics"
        And "Aron" should have no quests in his completed quests list


    Scenario: Tracking the amount of completed quests
        Given "Aron" has completed the quest with the title of "PBR basics"
        When "Aron" looks at his completed quests
        Then "Aron" his total amount of completed quests should be 1


    Scenario: Tracking the amount of category quests completed
        Given "Aron" has not completed a quest with the category of "texturing"
        When "Aron" completes a quest with a category of "texturing"
        Then "Aron" his "texturing" category quest completion amount should be 1


    Scenario: Seeing the completed quests of others
        Given "Glenn" has completed the quest with the title of "PBR basics"
        When "Aron" looks at the completed quests of "Glenn"
        Then "Aron" should see "Glenn" has completed a quest with the title of "PBR basics"


    Scenario: Seeing the amount of completed quests of others
        Given "Glenn" has completed the quest with the title of "PBR basics"
        When "Aron" looks at the completed quests of "Glenn"
        Then "Aron" should see "Glenn" has completed 1 quest
