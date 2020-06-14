<?php

namespace Firestark\Middlewares;

use Firestark\Http\Router;
use Firestark\Status;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as Handler;
use Psr\Http\Server\MiddlewareInterface as Middleware;

class RequestHandler implements Middleware
{
    private $router, $status = null;
    
    public function __construct(Router $router, Status $status)
    {
        $this->router = $router;
        $this->status = $status;
    }
    
    public function process(Request $request, Handler $handler): Response
    {
        $response = $this->router->dispatch($request);
        $status = $this->status->matched();
        return $response->withHeader('X-Firestark-Status', $status);
    }
}

