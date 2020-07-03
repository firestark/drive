<?php

use Psr\Http\Message\ResponseInterface;

Status::matching(1002, function(): ResponseInterface {
    return Response::ok([]);
});