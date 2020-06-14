Feature: Art director does daily quest
    In order to daily progress my knowledge in the gaming industry
    As an art director
    I need to be able to maintain a list of quests related to the gaming industry

    Background:
        Given an art director called "Aron" exists
        And an art director called "Glenn" exists
        And a quest with a title of "PBR basics",
            a description of "This tutorial will explain what PBR shading is.",
            a category of "texturing"
            and a time estimate of 5 - 10 minutes has been added to the list


    Scenario: Adding a new quest
        When an art director adds a quest with a title of "Unreal basics",
            a description of "This tutorial will explain the basics of the unreal engine workspace.",
            a category of "game engine"
            and a time estimate of 15 - 20 minutes to the list
        Then a quest with a title of "Unreal basics",
            a description of "This tutorial will explain the basics of the unreal engine workspace.",
            a category of "game engine"
            and a time estimate of 15 - 20 minutes is added to the list


    Scenario: Deny adding quests with existing titles
        When an art director adds a quest with a title of "PBR basics" to the list
        Then the art director should see a quest with a title of "PBR basics" already exists in the list
        And the quest with a title of "PBR basics" is not added to the list


    Scenario: Updating a quest with new information
        When an art director changes the description of the quest with a title of "PBR basics" to
            "This tutorial will make you a PBR master."
        Then the description of the quest with a title of "PBR basics" is now
            "This tutorial will make you a PBR master."


    Scenario: Deny updating quests to existing titles
        Given a quest with a title of "Unreal basics"
        When an art director updates the quest with a title of "unreal basics" to "PBR basics"
        Then the art director should see a quest with a title of "PBR basics" already exists in the list
        And the quest with a title of "Unreal basics" remains the same


    Scenario: Removing a no longer relevant quest
        When an art director removes a quest with a title of "PBR basics" from the list
        Then the quest with the title of "PBR basics" should no longer be in the list



## Possible feature files

- Art director maintains a list of quests
- Art director does daily quest from the quest list
- Art director looks for inspiration (from the quest list, from others)




## Features to add


- Filtering quests
    - Quests that are done by me are only visible in the 'done' list for me, for others that have not done the quest it is in the normal list
    - Quests can be filtered on category
- Track how many per category someone completed (This way we can gauge who has knowledge about a particular issue)


## Possible features

Do I want to see who has completed particular quests and on which day it was done?
Do I want to remove the quests from the list if they are completed by someone?
    If not, the list will grow infinite no matter if the quests where completed
    but we can make a remove functionality if quests are no longer relevant,
    we can also put these sort of quests in an archive so they are always there
    but never in the way

Do I want to keep personal lists and remove quests that are done by me?
Do I want to filter quests by if they are done by me?


Discovering new topics from done quests
    - Are there any keywords used in the quest (tutorial) that are interesting for a new quest?
    - Do you want to dive deeper in the specific quest topic you just did?

Quest recommendation
    - After you have done a quest you might want to recommend it to another art director
