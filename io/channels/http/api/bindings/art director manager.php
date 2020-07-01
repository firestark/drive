<?php

App::bind(ArtDirectorManager::class, function(): ArtDirectorManager {
    $file = __DIR__ . '/../../../../storage/databases/flatfile/art directors.data';

    $artDirectors = unserialize(file_get_contents($file));

    if (! is_array($artDirectors))
        $artDirectors = [];

    return new FlatFileArtDirectorManager($artDirectors, $file);
});