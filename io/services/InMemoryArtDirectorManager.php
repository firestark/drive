<?php

class InMemoryArtDirectorManager implements ArtDirectorManager
{
    private $artDirectors = [];

    public function add(ArtDirector $artDirector)
    {
        $this->artDirectors[$artDirector->name] = $artDirector;
    }

    public function all(): array
    {
        return $this->artDirectors;
    }

    public function find(string $name): ArtDirector
    {
        if (! $this->has($name))
            throw new Exception("An art director with name: $name does not exist.");

        return $this->artDirectors[$name];
    }

    public function has(string $name): bool
    {
        return isset($this->artDirectors[$name]);
    }

    public function identifies(ArtDirector $artDirector): bool
    {
        if (! $this->has($artDirector->name))
            return false;

        return $this->artDirectors[$artDirector->name]->matches($artDirector);
    }

    public function complete(ArtDirector $artDirector, Quest $quest)
    {
        if (! $this->has($artDirector->name))
            throw new Exception("An art director with name: $name does not exist.");

        $this->artDirectors[$artDirector->name]->complete($quest->title);
    }

    public function uncomplete(ArtDirector $artDirector, Quest $quest)
    {
        if (! $this->has($artDirector->name))
            throw new Exception("An art director with name: $name does not exist.");

        $this->artDirectors[$artDirector->name]->uncomplete($quest->title);
    }
}