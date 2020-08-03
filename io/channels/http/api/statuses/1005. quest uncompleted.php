<?php

use Psr\Http\Message\ResponseInterface;

Status::matching(1005, function(): ResponseInterface {
    return Response::ok('Quest uncompleted');
});