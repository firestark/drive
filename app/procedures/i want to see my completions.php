<?php

when('i want to see my completions', then(apply(a(
    
function(ArtDirector $artDirector) {
    return [1006, ['completions' => $artDirector->completed]];
}))));