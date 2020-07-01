<?php

namespace Middlewares;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as Handler;
use Psr\Http\Server\MiddlewareInterface as Middleware;

class InputMiddleware implements Middleware
{
   
    public function process(Request $request, Handler $handler): Response
    {
        foreach ($this->parseJson($request) as $key => $value)
            \Input::set($key, $value);
        
        return $handler->handle ( $request ); 
    }

    private function parseJson(Request $request): array
    {
        $query = (array) json_decode($request->getUri()->getQuery());
        $post = (array) json_decode($request->getBody());

        return array_merge($post, $query);
    }
}

