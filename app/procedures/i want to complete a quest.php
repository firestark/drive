<?php

when('i want to complete a quest', then(apply(a(
    
function(ArtDirector $artDirector, ArtDirectorManager $artDirectorManager, Quest $quest) {
    $artDirectorManager->complete($artDirector, $quest);
    return [1004, []];
}))));