<?php

namespace Firestark\Http;

use League\Route\Route;
use League\Route\Strategy\ApplicationStrategy;
use Psr\Http\Message\{ResponseInterface, ServerRequestInterface};

class Router extends \League\Route\Router
{	
	/**
     * {@inheritdoc}
     */
    public function dispatch(ServerRequestInterface $request): ResponseInterface
    {
		$this->routes = $this->sort($this->routes);

        if ($this->getStrategy() === null) {
            $this->setStrategy(new ApplicationStrategy);
        }

        $this->prepRoutes($request);

        /** @var Dispatcher $dispatcher */
        $dispatcher = (new Dispatcher($this->getData()))->setStrategy($this->getStrategy());

        foreach ($this->getMiddlewareStack() as $middleware) {
            if (is_string($middleware)) {
                $dispatcher->lazyMiddleware($middleware);
                continue;
            }

            $dispatcher->middleware($middleware);
        }

        return $dispatcher->dispatchRequest($request);
    }

    private function sort(array $routes): array
	{
		usort($routes, function(Route $a, Route $b)
		{
			return strcasecmp($a->getPath() , $b->getPath()); 
		});
		
		return $routes;
	}
}