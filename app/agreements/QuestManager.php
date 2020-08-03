<?php

abstract class QuestManager
{
    private $artDirectorManager = null;

    public function __construct(ArtDirectorManager $artDirectorManager)
    {
        $this->artDirectorManager = $artDirectorManager;
    }
    
    public function add(Quest $quest): bool
    {
        if ($this->has($quest->title))
            return false;    

        $this->create($quest);
        return true;
    }

    public function change(string $title, Quest $quest): bool
    {
        if ($this->has($quest->title) || $this->isLocked($title))
            return false;

        $this->update($title, $quest);
        return true;
    }

    public function remove(string $title): bool
    {
        if ($this->isLocked($title))
            return false;

        $this->delete($title);
        return true;
    }

    private function isLocked(string $title): bool
    {
        foreach ($this->artDirectorManager->all() as $artDirector)
            if ($artDirector->hasCompleted($title))
                return true;

        return false;
    }

    abstract public function all(): array;

    abstract public function find(string $title): Quest;

    abstract public function has(string $title): bool;

    abstract protected function create(Quest $quest);

    abstract protected function update(string $title, Quest $quest);

    abstract protected function delete(string $title);
}