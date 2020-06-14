Feature: Quest queue
    In order to keep track of the most interesting quests to do next
    As an art director
    I need to be able to maintain a queue of quests that I find most interesting


    Background:
        Given an art director called "Aron" exists
        And an art director called "Glenn" exists
        And a quest with a title of "PBR basics" has been added to the list


    Scenario: Adding a quest to the queue
        Given "Aron" has no quests in his queue
        When "Aron" adds a quest with a title of "PBR basics" to his queue
        Then "Aron" should have a quest with a title of "PBR basics" in his queue
        And the total amount of quests in "Aron" his queue should be 1


    Scenario: Seeing the quest queue of other art directors
        Given "Glenn" has a quest in his queue with a title of "PBR basics"
        When "Aron" looks at the quest queue of "Glenn"
        Then "Aron" should see "Glenn" has a quest in his queue with a title of "PBR basics"
        And the total amount of quests in "Glenn" his queue should be 1


## Possbile scenario's

- How to find new quests to put on the queue
