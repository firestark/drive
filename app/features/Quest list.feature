Feature: Quest list
    In order to have daily quests to do
    As an art director
    I need to be able to maintain a list of quests related to the gaming industry


    Background:
        Given an art director called "Aron" exists
        And an art director called "Glenn" exists
        And given the following quests exist: 
            | Title                 | Description                                           | Category         | Time estimate | More info                                                                                                                           |
            | PBR introduction      | A short introduction to PBR                           | Texturing        | 3 - 5 min     | PBR is a new improved workflow for texturing. Get to know PBR with this tutorial: https://www.youtube.com/watch?v=7NjGETJMZvY&t=85s |
            | Game genres explained | Every game genre has it charms, learn about them here | Idea exploration | 3 - 5 min     | Every game genre has it charms, learn about them here: https://www.youtube.com/watch?v=DSJvCffJCzE&t=15s                            |

        And "Aron" his done list is exactly as follows:
            | Quest            |
            | PBR introduction |


    Scenario: Adding a new quest
        When an art director adds the following quest:
            | Title                | Description                       | Category    | Time estimate | More info                                                                                         |
            | Unreal engine basics | Learn the basics of unreal engine | Game engine | 10 min        | Learn the basics of unreal engine with this tutorial: https://www.youtube.com/watch?v=_LaVvGlkBDs |

        Then the quest list is exactly as follows:
            | Title                 | Description                                           | Category         | Time estimate | More info                                                                                                                           |
            | PBR introduction      | A short introduction to PBR                           | Texturing        | 3 - 5 min     | PBR is a new improved workflow for texturing. Get to know PBR with this tutorial: https://www.youtube.com/watch?v=7NjGETJMZvY&t=85s |
            | Game genres explained | Every game genre has it charms, learn about them here | Idea exploration | 3 - 5 min     | Every game genre has it charms, learn about them here: https://www.youtube.com/watch?v=DSJvCffJCzE&t=15s                            |
            | Unreal engine basics  | Learn the basics of unreal engine                     | Game engine      | 10 min        | Learn the basics of unreal engine with this tutorial: https://www.youtube.com/watch?v=_LaVvGlkBDs                                   |


    Scenario: Deny adding quests with existing titles
        When an art director adds the following quest:
            | Title                 | Description      | Category  | Time estimate | More info      |
            | PBR introduction      | Some description | Texturing | 10 min        | Some more info |
        
        Then the art director should see a quest with a title of "PBR introduction" already exists in the list
        And the quest list is exactly as follows:
            | Title                 | Description                                           | Category         | Time estimate | More info                                                                                                                           |
            | PBR introduction      | A short introduction to PBR                           | Texturing        | 3 - 5 min     | PBR is a new improved workflow for texturing. Get to know PBR with this tutorial: https://www.youtube.com/watch?v=7NjGETJMZvY&t=85s |
            | Game genres explained | Every game genre has it charms, learn about them here | Idea exploration | 3 - 5 min     | Every game genre has it charms, learn about them here: https://www.youtube.com/watch?v=DSJvCffJCzE&t=15s                            |


    Scenario: Updating a quest
        When an art director updates a quest with the title of "PBR introduction" with the following information:
            | Title     | Description                                | Category      | Time estimate | More info                                                                                   |
            | PBR start | This PBR introduction will get you started | PBR Texturing | 5 min         | Get started with PBR using this tutorial: https://www.youtube.com/watch?v=7NjGETJMZvY&t=85s |

        Then the quest list is exactly as follows:
            | Title                 | Description                                           | Category         | Time estimate | More info                                                                                                |
            | PBR start             | This PBR introduction will get you started            | PBR Texturing    | 5 min         | Get started with PBR using this tutorial: https://www.youtube.com/watch?v=7NjGETJMZvY&t=85s              |
            | Game genres explained | Every game genre has it charms, learn about them here | Idea exploration | 3 - 5 min     | Every game genre has it charms, learn about them here: https://www.youtube.com/watch?v=DSJvCffJCzE&t=15s |

        And "Aron" his done list is exactly as follows:
            | Quest     |
            | PBR start |


    Scenario: Deny updating a quest title to an existing one
        When an art director updates a quest with the title of "PBR introduction" with the following information:
            | Title                 | Description      | Category | Time estimate | More info      |
            | Game genres explained | Some description | Misc     | 5 - 7 min     | Some more info |

        Then the art director should see a quest with a title of "Game genres explained" already exists in the list
        And the quest list is exactly as follows:
            | Title                 | Description                                           | Category         | Time estimate | More info                                                                                                                           |
            | PBR introduction      | A short introduction to PBR                           | Texturing        | 3 - 5 min     | PBR is a new improved workflow for texturing. Get to know PBR with this tutorial: https://www.youtube.com/watch?v=7NjGETJMZvY&t=85s |
            | Game genres explained | Every game genre has it charms, learn about them here | Idea exploration | 3 - 5 min     | Every game genre has it charms, learn about them here: https://www.youtube.com/watch?v=DSJvCffJCzE&t=15s                            |


    Scenario: Marking a quest done
        When "Aron" marks the quest with the title of "Game genres explained" as done
        Then "Aron" his done list is exactly as follows:
            | Quest                 |
            | PBR introduction      |
            | Game genres explained |