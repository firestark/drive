<?php

namespace Middlewares;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as Handler;
use Psr\Http\Server\MiddlewareInterface as Middleware;
use Services\Guard;

class AuthenticationMiddleware implements Middleware
{
    private $guard = null;

    public function __construct(Guard $guard)
    {
        $this->guard = $guard;
    }

    public function process(Request $request, Handler $handler): Response
    {
        $token = $request->getHeaderLine('Authorization');

        if (! $this->guard->validate($token))
            return $this->deny($request);
        
        $response = $handler->handle($request);
        return $response->withHeader('Authorization', $token);
    }

    private function deny(Request $request): Response
    {
        return \Response::forbidden();
    }
}

