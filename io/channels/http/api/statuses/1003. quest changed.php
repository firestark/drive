<?php

use Psr\Http\Message\ResponseInterface;

Status::matching(1003, function(): ResponseInterface {
    return Response::ok('Quest changed');
});