<?php

namespace Firestark\Http;

use Psr\Http\Message\ResponseInterface as Response;
use Laminas\Diactoros\Response\RedirectResponse as RedirectResponse;

class Redirector
{
    private $previous = '/';

    public function __construct(string $previous)
    {
        $this->previous = $previous;
    }

    public function to(string $uri): Response
    {
        return new RedirectResponse($uri);
    }

    public function back() : Response
    {
        return new RedirectResponse($this->previous);
    }
}