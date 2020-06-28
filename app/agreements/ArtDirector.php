<?php

class ArtDirector
{
    public $name = '';
    public $completed = [];

    public function __construct(string $name)
    {
        $this->name = $name;
    }

    public function complete(string $title)
    {
        $this->completed[$title] = $title;
    }

    public function uncomplete(string $title)
    {
        unset($this->completed[$title]);
    }

    public function hasCompleted(string $title): bool
    {
        return in_array($title, $this->completed);
    }
}
