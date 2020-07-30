<?php

use function compact as with;

when('i want to add a quest', then(apply(a(
    
function(Quest $quest, QuestManager $questManager) {
    if($questManager->add($quest))
        return [1001, with('quest')];

    return [2000, []];
}))));