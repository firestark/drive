<?php

use Laminas\Diactoros\Response\JsonResponse;

class Response
{
    public static function ok($data): JsonResponse
    {
        return new JsonResponse($data, 200, [
            'Access-Control-Allow-Origin' => '*',
            'Access-Control-Allow-Headers' => '*',
            'Access-Control-Allow-Methods' => 'GET, PUT, POST, DELETE, HEAD',
            'X-App-Status' => Status::matched()
        ]);
    }

    public static function conflict($data): JsonResponse
    {
        return new JsonResponse($data, 409, [
            'Access-Control-Allow-Origin' => '*',
            'Access-Control-Allow-Headers' => '*',
            'Access-Control-Allow-Methods' => 'GET, PUT, POST, DELETE, HEAD',
            'X-App-Status' => Status::matched()
        ]);
    }

    public static function forbidden($data = []): JsonResponse
    {
        return new JsonResponse($data, 403, [
            'Access-Control-Allow-Origin' => '*',
            'Access-Control-Allow-Headers' => '*',
            'Access-Control-Allow-Methods' => 'GET, PUT, POST, DELETE, HEAD',
        ]);
    }

    public static function unauthorized($data = []): JsonResponse
    {
        return new JsonResponse($data, 401, [
            'Access-Control-Allow-Origin' => '*',
            'Access-Control-Allow-Headers' => '*',
            'Access-Control-Allow-Methods' => 'GET, PUT, POST, DELETE, HEAD',
        ]);
    }
}