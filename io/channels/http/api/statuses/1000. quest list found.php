<?php

use Psr\Http\Message\ResponseInterface;

Status::matching(1000, function(array $quests): ResponseInterface {
    return Response::ok(array_values($quests));
});