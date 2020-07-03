<?php

when('i want to remove a quest', then(apply(a(
    
function(string $title, QuestManager $questManager) {
    if ($questManager->remove($title))
        return [1002, []];

    return [2000, []];
}))));