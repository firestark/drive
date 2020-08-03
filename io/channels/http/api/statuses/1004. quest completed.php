<?php

use Psr\Http\Message\ResponseInterface;

Status::matching(1004, function(): ResponseInterface {
    return Response::ok('Quest completed');
});