<?php

App::bind(QuestManager::class, function(): QuestManager {
    $file = __DIR__ . '/../../../../storage/databases/flatfile/quests.data';
    $quests = unserialize(file_get_contents($file));

    if (! is_array($quests))
        $quests = [];

    $artDirectorManager = App::make(ArtDirectorManager::class);
    return new FlatFileQuestManager($file, $quests, $artDirectorManager);
});