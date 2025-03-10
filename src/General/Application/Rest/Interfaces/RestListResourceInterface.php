<?php

declare(strict_types=1);

namespace App\General\Application\Rest\Interfaces;

use App\General\Domain\Entity\Interfaces\EntityInterface;
use Throwable;

/**
 * Interface RestListResourceInterface
 *
 * @package App\General
 */
interface RestListResourceInterface
{
    /**
     * Generic find method to return an array of items from database. Return value is an array of specified repository
     * entities.
     *
     * @param array<int|string, string|array<mixed>>|null $criteria
     * @param array<string, string>|null $orderBy
     * @param array<string, string>|null $search
     *
     * @throws Throwable
     *
     * @return array<int, EntityInterface>
     */
    public function find(
        ?array $criteria = null,
        ?array $orderBy = null,
        ?int $limit = null,
        ?int $offset = null,
        ?array $search = null,
        ?string $entityManagerName = null
    ): array;
}
