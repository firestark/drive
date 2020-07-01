<?php

Status::matching(2000, function() {
    return Response::conflict(['reason' => 'Quest title already exists']);
});