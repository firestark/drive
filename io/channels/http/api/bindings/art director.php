<?php

App::bind(ArtDirector::class, function(string $name, string $password): ArtDirector {
    return new ArtDirector($name, $password);
});