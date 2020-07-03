<?php

interface ArtDirectorManager
{
    public function add(ArtDirector $artDirector);

    public function all(): array;

    public function find(string $name): ArtDirector;

    public function has(string $name): bool;

    public function identifies(ArtDirector $artDirector): bool;
}