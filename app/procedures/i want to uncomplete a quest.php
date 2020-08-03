<?php

when('i want to uncomplete a quest', then(apply(a(
    
function(ArtDirector $artDirector, ArtDirectorManager $artDirectorManager, Quest $quest) {
    $artDirectorManager->uncomplete($artDirector, $quest);
    return [1005, []];
}))));