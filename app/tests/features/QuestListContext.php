<?php

use Behat\Behat\Tester\Exception\PendingException;
use Behat\Behat\Context\Context;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;

require __DIR__ . '/start.php';

/**
 * Defines application features from the specific context.
 */
class QuestListContext implements Context
{
    private $questManager = null;
    private $artDirectorManager = null;

    public function __construct()
    {
        $this->artDirectorManager = new InMemoryArtDirectorManager;
        $this->questManager = new InMemoryQuestManager($this->artDirectorManager);
    }

    /**
     * @Given an art director called :name exists
     */
    public function anArtDirectorCalledExists(string $name)
    {
        $this->artDirectorManager->add(new ArtDirector($name, ''));
    }

    /**
     * @Given given the following quests exist:
     */
    public function givenTheFollowingQuestsExist(TableNode $table)
    {
        foreach ($table->getHash() as $row)
            $this->questManager->add($this->newQuest($row));
            
    }

    /**
     * @Given :name his completion list is exactly as follows:
     */
    public function hisCompletionListIsExactlyAsFollows(string $name, TableNode $table)
    {
        foreach ($table->getHash() as $row)
            $this->artDirectorManager->find($name)->complete($row['Quest']);
    }

    /**
     * @When an art director adds the following quest:
     */
    public function anArtDirectorAddsTheFollowingQuest(TableNode $table)
    {
        foreach ($table->getHash() as $row)
            App::make('i want to add a quest', ['quest' => $this->newQuest($row), 'questManager' => $this->questManager]);        
    }

    /**
     * @Then the quest list is exactly as follows:
     */
    public function theQuestListIsExactlyAsFollows(TableNode $table)
    {
        foreach ($table->getHash() as $row)
            $quests[] = $this->newQuest($row);

        if ($this->validate($quests))
            return;
        

        $message = '----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------';
        $message .= PHP_EOL;
        $message .= 'I got the following quest list:';
        $message .= PHP_EOL;
        $message .= PHP_EOL;
        $message .= $this->generateTable(array_values($this->questManager->all()));
        throw new Exception($message);
    }

    /**
     * @Then the art director should see a quest with a title of :title already exists in the list
     */
    public function theArtDirectorShouldSeeAQuestWithATitleOfAlreadyExistsInTheList(string $title)
    {
        // ---
    }

    /**
     * @When an art director updates a quest with the title of :title with the following information:
     */
    public function anArtDirectorUpdatesAQuestWithTheTitleOfWithTheFollowingInformation(string $title, TableNode $table)
    {
        foreach ($table->getHash() as $row)
            App::make('i want to change a quest', ['title' => $title, 'quest' => $this->newQuest($row), 'questManager' => $this->questManager]);
    }

    /**
     * @Then the art director should see a quest with a title of :title is completed by an art director
     */
    public function theArtDirectorShouldSeeAQuestWithATitleOfIsCompletedByAnArtDirector(string $title)
    {
        // ---
    }

    /**
     * @When an art director removes the quest with a title of :title
     */
    public function anArtDirectorRemovesTheQuestWithATitleOf(string $title)
    {
        App::make('i want to remove a quest', ['title' => $title, 'questManager' => $this->questManager]);
    }

    /**
     * @When :name completes the quest with the title of :title
     */
    public function completesTheQuestWithTheTitleOf(string $name, string $title)
    {
        App::make('i want to complete a quest', [
            'artDirector' => $this->artDirectorManager->find($name),
            'ArtDirectorManager' => $this->artDirectorManager,
            'quest' => $this->questManager->find($title)
        ]);
    }

    /**
     * @When :name uncompletes the quest with the title of :title
     */
    public function uncompletesTheQuestWithTheTitleOf(string $name, string $title)
    {
        App::make('i want to uncomplete a quest', [
            'artDirector' => $this->artDirectorManager->find($name),
            'ArtDirectorManager' => $this->artDirectorManager,
            'quest' => $this->questManager->find($title)
        ]);
    }

    /**
     * @Then :name his new completion list is exactly as follows:
     */
    public function hisNewCompletionListIsExactlyAsFollows(string $name, TableNode $table)
    {
        foreach ($table->getHash() as $row)
            if (! $this->artDirectorManager->find($name)->hasCompleted($row['Quest']))
                throw new Exception("I can find the quest: {$row['Quest']} in my completions.");

    }

    /**
     * @Then :name his new completion list is exactly empty
     */
    public function hisNewCompletionListIsExactlyEmpty(string $name)
    {
        if (! empty($this->artDirectorManager->find($name)->completed))
            throw new Exception('I expected my completion list to be empty but it is not.');
    }

    private function newQuest(array $data): Quest
    {
        return new Quest($data['Title'], $data['Description'], $data['Category'], $data['Time estimate'], $data['More info']);
    }

    private function generateTable(array $quests)
    {
        $tableBuilder = new \MaddHatter\MarkdownTable\Builder();
        $tableBuilder
            ->headers(['Title','Description','Category', 'Time estimate', 'More info']);


        foreach ($quests as $quest)
            $tableBuilder->row([$quest->title, $quest->description, $quest->category, $quest->timeEstimate, $quest->moreInfo]);

        return $tableBuilder->render();
    }

    private function validate(array $quests): bool
    {
        foreach ($quests as $quest)
            if (! $this->contains($quest))
                return false;

        return true;
    }

    private function contains(Quest $quest): bool
    {
        foreach ($this->questManager->all() as $questInList)
            if (md5(serialize($quest)) === md5(serialize($questInList)))
                return true;

        return false;
    }
}
