<?php

use Behat\Behat\Tester\Exception\PendingException;
use Behat\Behat\Context\Context;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;

/**
 * Defines application features from the specific context.
 */
class FeatureContext implements Context
{
    /**
     * @Given an art director called :arg1 exists
     */
    public function anArtDirectorCalledExists($arg1)
    {
        throw new PendingException();
    }

    /**
     * @Given given the following quests exist:
     */
    public function givenTheFollowingQuestsExist(TableNode $table)
    {
        throw new PendingException();
    }

    /**
     * @Given :arg1 his done list is exactly as follows:
     */
    public function hisDoneListIsExactlyAsFollows($arg1, TableNode $table)
    {
        throw new PendingException();
    }

    /**
     * @When an art director adds the following quest:
     */
    public function anArtDirectorAddsTheFollowingQuest(TableNode $table)
    {
        throw new PendingException();
    }

    /**
     * @Then the quest list is exactly as follows:
     */
    public function theQuestListIsExactlyAsFollows(TableNode $table)
    {
        throw new PendingException();
    }

    /**
     * @Then the art director should see a quest with a title of :arg1 already exists in the list
     */
    public function theArtDirectorShouldSeeAQuestWithATitleOfAlreadyExistsInTheList($arg1)
    {
        throw new PendingException();
    }

    /**
     * @When an art director updates a quest with the title of :arg1 with the following information:
     */
    public function anArtDirectorUpdatesAQuestWithTheTitleOfWithTheFollowingInformation($arg1, TableNode $table)
    {
        throw new PendingException();
    }

    /**
     * @When :arg1 marks the quest with the title of :arg2 as done
     */
    public function marksTheQuestWithTheTitleOfAsDone($arg1, $arg2)
    {
        throw new PendingException();
    }
}
