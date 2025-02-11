<?php

declare(strict_types=1);

namespace App\General\Application\Rest\Interfaces;

use App\General\Domain\Entity\Interfaces\EntityInterface;
use Throwable;

/**
 * Interface RestSaveResourceInterface
 *
 * @package App\General
 */
interface RestSaveResourceInterface
{
    /**
     * Generic method to save given entity to specified repository. Return value is created entity.
     *
     * @throws Throwable
     */
    public function save(
        EntityInterface $entity,
        ?bool $flush = null,
        ?bool $skipValidation = null,
        ?string $entityManagerName = null
    ): EntityInterface;
}
