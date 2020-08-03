<?php

class InMemoryQuestManager extends QuestManager
{
    private $quests = [];

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
    }

    protected function update(string $title, Quest $quest)
    {
        $this->remove($title);
        $this->quests[$quest->title] = $quest;
    }

    protected function delete(string $title)
    {
        unset($this->quests[$title]);
    }

    public function has(string $title): bool
    {
        return isset($this->quests[$title]);
    }
}