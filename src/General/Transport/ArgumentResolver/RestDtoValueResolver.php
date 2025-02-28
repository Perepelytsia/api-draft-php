<?php

declare(strict_types=1);

namespace App\General\Transport\ArgumentResolver;

use App\General\Application\DTO\Interfaces\RestDtoInterface;
use App\General\Transport\Rest\Controller;
use App\General\Transport\Rest\ControllerCollection;
use AutoMapperPlus\AutoMapperInterface;
use BadMethodCallException;
use Generator;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Controller\ArgumentValueResolverInterface;
use Symfony\Component\HttpKernel\ControllerMetadata\ArgumentMetadata;
use Throwable;

use function count;
use function explode;
use function in_array;

/**
 * Class RestDtoValueResolver
 *
 * @package App\General
 */
class RestDtoValueResolver implements ArgumentValueResolverInterface
{
    private const CONTROLLER_KEY = '_controller';

    /**
     * @var array<int, string>
     */
    private array $supportedActions = [
        Controller::ACTION_CREATE,
        Controller::ACTION_UPDATE,
        Controller::ACTION_PATCH,
    ];

    /**
     * @var array<string, string>
     */
    private array $actionMethodMap = [
        Controller::ACTION_CREATE => Controller::METHOD_CREATE,
        Controller::ACTION_UPDATE => Controller::METHOD_UPDATE,
        Controller::ACTION_PATCH => Controller::METHOD_PATCH,
    ];

    private ?string $controllerName = null;
    private ?string $actionName = null;

    /**
     * Constructor
     *
     * @param ControllerCollection<Controller> $controllerCollection
     */
    public function __construct(
        private readonly ControllerCollection $controllerCollection,
        private readonly AutoMapperInterface $autoMapper,
    ) {
    }

    /**
     * {@inheritdoc}
     */
    public function supports(Request $request, ArgumentMetadata $argument): bool
    {
        $bits = explode('::', (string)$request->attributes->get(self::CONTROLLER_KEY, ''));

        if (count($bits) !== 2) {
            return false;
        }

        [$controllerName, $actionName] = $bits;

        $output = $argument->getType() === RestDtoInterface::class
            && in_array($actionName, $this->supportedActions, true)
            && $this->controllerCollection->has($controllerName);

        if ($output === true) {
            $this->controllerName = $controllerName;
            $this->actionName = $actionName;
        }

        return $output;
    }

    /**
     * {@inheritdoc}
     *
     * @return Generator<RestDtoInterface>
     *
     * @throws Throwable
     */
    public function resolve(Request $request, ArgumentMetadata $argument): Generator
    {
        if ($this->controllerName === null || $this->actionName === null) {
            $message = sprintf(
                'You cannot call `%1$s::resolve(...)` method without calling `%1$s::supports(...)` first',
                self::class,
            );

            throw new BadMethodCallException($message);
        }

        $dtoClass = $this->controllerCollection
            ->get($this->controllerName)
            ->getDtoClass($this->actionMethodMap[$this->actionName] ?? null);

        yield $this->autoMapper->map($request, $dtoClass);
    }
}
