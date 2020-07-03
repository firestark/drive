<?php

use Psr\Http\Message\ResponseInterface;

Status::matching(2000, function(): ResponseInterface {
    return Response::conflict(['reason' => 'Quest title already exists']);
});