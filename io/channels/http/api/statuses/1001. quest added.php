<?php

use Psr\Http\Message\ResponseInterface;

Status::matching(1001, function(): ResponseInterface {
    return Response::ok('Quest added');
});