<?php

use Psr\Http\Message\ResponseInterface;

Status::matching(2001, function(): ResponseInterface {
    return Response::conflict([]);
});