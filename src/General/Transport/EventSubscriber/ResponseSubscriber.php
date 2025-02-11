<?php

declare(strict_types=1);

namespace App\General\Transport\EventSubscriber;

use App\Tool\Application\Service\VersionService;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Event\ResponseEvent;

/**
 * Class ResponseSubscriber
 *
 * @package App\General
 */
class ResponseSubscriber implements EventSubscriberInterface
{
    public function __construct(
        private readonly VersionService $version,
    ) {
    }

    /**
     * {@inheritdoc}
     *
     * @return array<string, array<int, string|int>>
     */
    public static function getSubscribedEvents(): array
    {
        return [
            ResponseEvent::class => [
                'onKernelResponse',
                10,
            ],
        ];
    }

    /**
     * Subscriber method to attach API version to every response.
     */
    public function onKernelResponse(ResponseEvent $event): void
    {
        // Attach new header
        $event->getResponse()->headers->add([
            'X-API-VERSION' => $this->version->get(),
        ]);
    }
}
