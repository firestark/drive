<?php declare(strict_types=1);

namespace Firestark\Http;

use FastRoute\Dispatcher as FastRoute;
use League\Route\Route;
use Psr\Http\Message\{ResponseInterface, ServerRequestInterface};

class Dispatcher extends \League\Route\Dispatcher 
{
    /**
     * Dispatch the current route
     *
     * @param ServerRequestInterface $request
     *
     * @return ResponseInterface
     */
    public function dispatchRequest(ServerRequestInterface $request): ResponseInterface
    {
        $httpMethod = $request->getMethod();
        $uri        = $request->getUri()->getPath();
        $match      = $this->dispatch($httpMethod, $uri);

        foreach ($match[2] as $key => $value)
            \Input::set($key, $value);

        switch ($match[0]) {
            case FastRoute::NOT_FOUND:
                $this->setNotFoundDecoratorMiddleware();
                break;
            case FastRoute::METHOD_NOT_ALLOWED:
                $allowed = (array) $match[1];
                $this->setMethodNotAllowedDecoratorMiddleware($allowed);
                break;
            case FastRoute::FOUND:
                $route = $this->ensureHandlerIsRoute($match[1], $httpMethod, $uri)->setVars($match[2]);
                $this->setFoundMiddleware($route);
                break;
        }

        return $this->handle($request);
    }

    /**
     * Ensure handler is a Route, honoring the contract of dispatchRequest.
     *
     * @param Route|mixed $matchingHandler
     * @param string      $httpMethod
     * @param string      $uri
     *
     * @return Route
     *
     */
    private function ensureHandlerIsRoute($matchingHandler, $httpMethod, $uri): Route
    {
        if (is_a($matchingHandler, Route::class)) {
            return $matchingHandler;
        }
        return new Route($httpMethod, $uri, $matchingHandler);
    }
}
