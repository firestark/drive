<?php

class FlatFileArtDirectorManager implements ArtDirectorManager
{
    private $artDirectors = [];
    private $file = '';

    public function __construct(array $artDirectors, string $file)
    {
        $this->artDirectors = $artDirectors;
        $this->file = $file;
    }

    public function add(ArtDirector $artDirector)
    {
        $this->artDirectors[$artDirector->name] = $artDirector;
        $this->write();
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
        $this->write();
    }

    public function uncomplete(ArtDirector $artDirector, Quest $quest)
    {
        if (! $this->has($artDirector->name))
            throw new Exception("An art director with name: $name does not exist.");

        $this->artDirectors[$artDirector->name]->uncomplete($quest->title);
        $this->write();
    }

    private function write()
    {
        file_put_contents($this->file, serialize($this->artDirectors));
    }
}