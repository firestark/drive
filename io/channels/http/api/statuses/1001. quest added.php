<?php

use Psr\Http\Message\ResponseInterface;

Status::matching(1001, function(Quest $quest): ResponseInterface {
    return Response::ok($quest);
});