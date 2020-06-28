Feature: Quest list
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


    Scenario: Adding a new quest
        When an art director adds the following quest:
            | Title                | Description                       | Category    | Time estimate | More info                                                                                         |
            | Unreal engine basics | Learn the basics of unreal engine | Game engine | 10 min        | Learn the basics of unreal engine with this tutorial: https://www.youtube.com/watch?v=_LaVvGlkBDs |

        Then the quest list is exactly as follows:
            | Title                 | Description                                           | Category         | Time estimate | More info                                                                                                                           |
            | PBR introduction      | A short introduction to PBR                           | Texturing        | 3 - 5 min     | PBR is a new improved workflow for texturing. Get to know PBR with this tutorial: https://www.youtube.com/watch?v=7NjGETJMZvY&t=85s |
            | Game genres explained | Every game genre has it's charms, learn about them here | Idea exploration | 3 - 5 min     | Every game genre has it's charms, learn about them here: https://www.youtube.com/watch?v=DSJvCffJCzE&t=15s                        |
            | Unreal engine basics  | Learn the basics of unreal engine                     | Game engine      | 10 min        | Learn the basics of unreal engine with this tutorial: https://www.youtube.com/watch?v=_LaVvGlkBDs                                   |


    Scenario: Deny adding quests with existing titles
        When an art director adds the following quest:
            | Title                 | Description      | Category  | Time estimate | More info      |
            | PBR introduction      | Some description | Texturing | 10 min        | Some more info |

        Then the art director should see a quest with a title of "PBR introduction" already exists in the list
        And the quest list is exactly as follows:
            | Title                 | Description                                           | Category         | Time estimate | More info                                                                                                                           |
            | PBR introduction      | A short introduction to PBR                           | Texturing        | 3 - 5 min     | PBR is a new improved workflow for texturing. Get to know PBR with this tutorial: https://www.youtube.com/watch?v=7NjGETJMZvY&t=85s |
            | Game genres explained | Every game genre has it's charms, learn about them here | Idea exploration | 3 - 5 min     | Every game genre has it's charms, learn about them here: https://www.youtube.com/watch?v=DSJvCffJCzE&t=15s                        |


    Scenario: Updating a quest
        When an art director updates a quest with the title of "PBR introduction" with the following information:
            | Title     | Description        | Category      | Time estimate | More info                   |
            | PBR start | Start learning PBR | PBR texturing | 5 min         | PBR is a wonderful workflow |

        Then the quest list is exactly as follows:
            | Title                 | Description                                           | Category         | Time estimate | More info                                                                                                    |
            | PBR start             | Start learning PBR                                    | PBR texturing    | 5 min         | PBR is a wonderful workflow                                                                                  |
            | Game genres explained | Every game genre has it's charms, learn about them here | Idea exploration | 3 - 5 min     | Every game genre has it's charms, learn about them here: https://www.youtube.com/watch?v=DSJvCffJCzE&t=15s |


    Scenario: Deny updating a quest title to an existing quest title
        When an art director updates a quest with the title of "PBR introduction" with the following information:
            | Title                 | Description      | Category | Time estimate | More info      |
            | Game genres explained | Some description | Misc.    | 5 - 7 min     | Some more info |

        Then the art director should see a quest with a title of "Game genres explained" already exists in the list
        And the quest list is exactly as follows:
            | Title                 | Description                                           | Category         | Time estimate | More info                                                                                                                           |
            | PBR introduction      | A short introduction to PBR                           | Texturing        | 3 - 5 min     | PBR is a new improved workflow for texturing. Get to know PBR with this tutorial: https://www.youtube.com/watch?v=7NjGETJMZvY&t=85s |
            | Game genres explained | Every game genre has it's charms, learn about them here | Idea exploration | 3 - 5 min     | Every game genre has it's charms, learn about them here: https://www.youtube.com/watch?v=DSJvCffJCzE&t=15s                        |


    Scenario: Deny updating a quest if the quest is completed by any art director
        When an art director updates a quest with the title of "Game genres explained" with the following information:
            | Title       | Description      | Category | Time estimate | More info      |
            | Game genres | Some description | Misc.    | 5 - 7 min     | Some more info |

        Then the art director should see a quest with a title of "Game genres explained" is completed by an art director
        And the quest list is exactly as follows:
            | Title                 | Description                                           | Category         | Time estimate | More info                                                                                                                           |
            | PBR introduction      | A short introduction to PBR                           | Texturing        | 3 - 5 min     | PBR is a new improved workflow for texturing. Get to know PBR with this tutorial: https://www.youtube.com/watch?v=7NjGETJMZvY&t=85s |
            | Game genres explained | Every game genre has it's charms, learn about them here | Idea exploration | 3 - 5 min     | Every game genre has it's charms, learn about them here: https://www.youtube.com/watch?v=DSJvCffJCzE&t=15s                        |


    Scenario: Removing a quest
        When an art director removes the quest with a title of "PBR introduction"
        Then the quest list is exactly as follows:
            | Title                 | Description                                             | Category         | Time estimate | More info                                                                                                  |
            | Game genres explained | Every game genre has it's charms, learn about them here | Idea exploration | 3 - 5 min     | Every game genre has it's charms, learn about them here: https://www.youtube.com/watch?v=DSJvCffJCzE&t=15s |


    Scenario: Deny removing a quest that is completed by any art director
        When an art director removes the quest with a title of "Game genres explained"
        Then the art director should see a quest with a title of "Game genres explained" is completed by an art director
        And the quest list is exactly as follows:
            | Title                 | Description                                           | Category         | Time estimate | More info                                                                                                                           |
            | PBR introduction      | A short introduction to PBR                           | Texturing        | 3 - 5 min     | PBR is a new improved workflow for texturing. Get to know PBR with this tutorial: https://www.youtube.com/watch?v=7NjGETJMZvY&t=85s |
            | Game genres explained | Every game genre has it's charms, learn about them here | Idea exploration | 3 - 5 min     | Every game genre has it's charms, learn about them here: https://www.youtube.com/watch?v=DSJvCffJCzE&t=15s                        |
