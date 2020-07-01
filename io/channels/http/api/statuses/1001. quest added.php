<?php

Status::matching(1001, function() {
    return Response::ok('Quest added');
});