<?php

when('i want to change a quest', then(apply(a(
    
function(string $title, Quest $quest, QuestManager $questManager) {
    if ($questManager->change($title, $quest))
        return [1003, []];

    return [2001, []];
}))));