<?php

class ArtDirector implements JsonSerializable
{
    private $name = '';
    private $completed = [];
    private $password = '';

    public function __construct(string $name, string $password)
    {
        $this->name = $name;
        $this->password = md5($password);
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
        return isset($this->completed[$title]);
    }

    public function matches(ArtDirector $artDirector): bool
    {
        return $this->name === $artDirector->name and $this->password === $artDirector->password;
    }

    public function __get(string $property)
    {
        if (isset($this->{$property}))
            return $this->{$property};
    }

    public function jsonSerialize(): array
    {
        return [
            'name'      => $this->name,
            'completed' => $this->completed,
        ];
    }
}
