<?php

status::matching(1000, function(array $quests) {
    return Response::ok(array_values($quests));
});