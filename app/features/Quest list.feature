Feature: Quest list
    In order to have daily quests to do
    As an art director
    I need to be able to maintain a list of quests related to the gaming industry


    Background:
        Given an art director called "Aron" exists
        And an art director called "Glenn" exists
        And given the following quests exist:
            | Title          | Description                                     | Category    | Time estimate (minutes) | Creation date |
            | PBR basics     | This tutorial will explain what PBR shading is. | Texturing   | 5 - 10                  | 6 June 2020   |
            | Blender basics | Learn the basics of blender.                    | 3D modeling | 5 - 10                  | 5 June 2020   |


    Scenario: Adding a new quest
        When an art director adds the following quest:
            | Title         | Description                               | Category    | Time estimate (minutes) | Creation date |
            | Unreal basics | This tutorial will explain unreal engine. | Game engine | 15 - 20                 | 7 June 2020   |

        Then the quest list is exactly as follows:
            | Title          | Description                                     | Category    | Time estimate (minutes) | Creation date |
            | Unreal basics  | This tutorial will explain unreal engine.       | Game engine | 15 - 20                 | 7 June 2020   |
            | PBR basics     | This tutorial will explain what PBR shading is. | Texturing   | 5 - 10                  | 6 June 2020   |
            | Blender basics | Learn the basics of blender.                    | 3D modeling | 5 - 10                  | 5 June 2020   |


    Scenario: Deny adding quests with existing titles
        When an art director adds a quest with a title of "PBR basics" to the list
        Then the art director should see a quest with a title of "PBR basics" already exists in the list
        And the quest list is exactly as follows:
            | Title          | Description                                     | Category    | Time estimate (minutes) | Creation date |
            | PBR basics     | This tutorial will explain what PBR shading is. | Texturing   | 5 - 10                  | 6 June 2020   |
            | Blender basics | Learn the basics of blender.                    | 3D modeling | 5 - 10                  | 5 June 2020   |


    Scenario: Updating a quest with new information
        When an art director changes the description of the quest with a title of "PBR basics" to
            "This tutorial will make you a PBR master."
        Then the quest list is exactly as follows:
            | Title          | Description                               | Category    | Time estimate (minutes) | Creation date |
            | PBR basics     | This tutorial will make you a PBR master. | Texturing   | 5 - 10                  | 6 June 2020   |
            | Blender basics | Learn the basics of blender.              | 3D modeling | 5 - 10                  | 5 June 2020   |


    Scenario: Deny updating quests to existing titles
        When an art director updates the quest with a title of "Blender basics" to "PBR basics"
        Then the art director should see a quest with a title of "PBR basics" already exists in the list
        And the quest list is exactly as follows:
            | Title          | Description                                     | Category    | Time estimate (minutes) | Creation date |
            | PBR basics     | This tutorial will explain what PBR shading is. | Texturing   | 5 - 10                  | 6 June 2020   |
            | Blender basics | Learn the basics of blender.                    | 3D modeling | 5 - 10                  | 5 June 2020   |


    Scenario: Removing a no longer relevant quest
        When an art director removes a quest with a title of "PBR basics" from the list
        Then the quest list is exactly as follows:
            | Title          | Description                  | Category    | Time estimate (minutes) | Creation date |
            | Blender basics | Learn the basics of blender. | 3D modeling | 5 - 10                  | 5 June 2020   |
