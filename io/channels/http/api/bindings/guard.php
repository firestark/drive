<?php

use Services\Guard;

App::bind(Guard::class, function(): Guard {
    return new Guard(App::make(ArtDirectorManager::class));
});