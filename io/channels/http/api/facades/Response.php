<?php

use Laminas\Diactoros\Response\JsonResponse;

class Response
{
    public static function ok($data): JsonResponse
    {
        return new JsonResponse($data, 200, [
            'X-App-Status' => Status::matched()
        ]);
    }

    public static function conflict($data): JsonResponse
    {
        return new JsonResponse($data, 409, [
            'X-App-Status' => Status::matched()
        ]);
    }

    public static function forbidden(): JsonResponse
    {
        return new JsonResponse([], 403);
    }

    public static function unauthorized(): JsonResponse
    {
        return new JsonResponse([], 401);
    }
}