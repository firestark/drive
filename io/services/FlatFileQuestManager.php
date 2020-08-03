<?php

class FlatFileQuestManager extends QuestManager
{
    private $file = '';
    private $quests = [];

    public function __construct(string $file, array $quests, ArtDirectorManager $artDirectorManager)
    {
        $this->file = $file;
        $this->quests = $quests;
        parent::__construct($artDirectorManager);
    }

    public function all(): Array
    {
        return $this->quests;
    }

    public function find(string $title): Quest
    {
        if (! $this->has($title))
            throw new Exception("Can't find a quest with title: {$title}.");

        return $this->quests[$title];
    }

    protected function create(Quest $quest)
    {
        $this->quests[$quest->title] = $quest;
        $this->write();
    }

    protected function update(string $title, Quest $quest)
    {
        $this->remove($title);
        $this->quests[$quest->title] = $quest;
        $this->write();
    }

    protected function delete(string $title)
    {
        unset($this->quests[$title]);
        $this->write();
    }

    public function has(string $title): bool
    {
        return isset($this->quests[$title]);
    }

    private function write()
    {
        file_put_contents($this->file, serialize($this->quests));
    }
}