<?php

use Psr\Http\Message\ResponseInterface;

Status::matching(1006, function(array $completions): ResponseInterface {
    return Response::ok(array_values($completions));
});