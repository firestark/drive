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

        And given "Aron" his completed quest list looks like follows:
            | Title         | Category    | Completion date |
            | Unreal basics | Game engine | 6 June 2020     |

    Scenario: Completing a quest
        When "Aron" completes the quest with the title of "PBR basics"
        Then "Aron" should see he has completed the quest with the title of "PBR basics"
        And "Aron" his completed quest list looks like follows:
            | Title         | Category    | Completion date |
            | PBR basics    | Texturing   | today           |
            | Unreal basics | Game engine | 6 June 2020     |


    Scenario: Uncomplete a quest
        When "Aron" uncompletes the quest with the title of "Unreal basics"
        Then "Aron" should see he has uncompleted the quest with the title of "Unreal basics"
        And "Aron" should have no quests in his completed quests list


    Scenario: Tracking the amount of completed quests
        When "Aron" looks at his completed quests amount
        Then "Aron" should see his total amount of completed quests is 1


    Scenario: Tracking the amount of category quests completed
        When "Aron" looks at his completed quest amount for the category of "Game engine"
        Then "Aron" should see he has completed 1 quest with a category of "Game engine"


    Scenario: Seeing the completed quests of others
        Given "Glenn" his completed quest list looks like follows:
            | Title      | Category    | Completion date |
            | PBR basics | Texturing   | 1 June 2020     |

        When "Aron" looks at the completed quests of "Glenn"
        Then "Aron" should see "Glenn" has completed the following quests:
            | Title      | Category    | Completion date |
            | PBR basics | Texturing   | 1 June 2020     |


    Scenario: Seeing the amount of completed quests of others
        Given "Glenn" his completed quest list looks like follows:
            | Title      | Category    | Completion date |
            | PBR basics | Texturing   | 1 June 2020     |

        When "Aron" looks at the completed quests of "Glenn"
        Then "Aron" should see "Glenn" has completed 1 quest


    Scenario: Seeing the amount of completed category quests of others
        Given "Glenn" his completed quest list looks like follows:
            | Title      | Category    | Completion date |
            | PBR basics | Texturing   | 1 June 2020     |
        When "Aron" looks at "Glenn" his completed quests with a category of "Texturing"
        Then "Aron" should see "Glenn" has completed 1 quest with a category of "Texturing"
