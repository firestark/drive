<?php

when('i want to see my completions for today', then(apply(a(
    
function(ArtDirector $artDirector) {

    $completions = $artDirector->completed;

    foreach ($completions as $completion)
        if ($completion->isToday())
            $todaysCompletions[] = $completion;

    return [1006, ['completions' => $todaysCompletions ?? []]];
}))));