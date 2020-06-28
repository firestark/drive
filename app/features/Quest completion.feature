Feature: Quest completion
    In order to daily progress my knowledge in the gaming industry
    As an art director
    I need to be able to maintain a list of short tutorials, called quests, related to the gaming industry


    Background:
        Given an art director called "Aron" exists
        And an art director called "Glenn" exists
        And given the following quests exist:
            | Title                 | Description                                           | Category         | Time estimate | More info                                                                                                                           |
            | PBR introduction      | A short introduction to PBR                           | Texturing        | 3 - 5 min     | PBR is a new improved workflow for texturing. Get to know PBR with this tutorial: https://www.youtube.com/watch?v=7NjGETJMZvY&t=85s |
            | Game genres explained | Every game genre has it's charms, learn about them here | Idea exploration | 3 - 5 min     | Every game genre has it's charms, learn about them here: https://www.youtube.com/watch?v=DSJvCffJCzE&t=15s                        |

        And "Aron" his completion list is exactly as follows:
            | Quest                 |
            | Game genres explained |


    Scenario: Completing a quest
        When "Aron" completes the quest with the title of "PBR introduction"
        Then "Aron" his new completion list is exactly as follows:
            | Quest                 |
            | Game genres explained |
            | PBR introduction      |


    Scenario: Uncompleting a quest
        When "Aron" uncompletes the quest with the title of "Game genres explained"
        Then "Aron" his new completion list is exactly empty