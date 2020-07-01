<?php

when('i want to see the quest list', then(apply(a(
    
function(QuestManager $questManager) {
    return [1000, ['quests' => $questManager->all()]];
}))));