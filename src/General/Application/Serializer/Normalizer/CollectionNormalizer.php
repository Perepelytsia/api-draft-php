<?php

declare(strict_types=1);

namespace App\General\Application\Serializer\Normalizer;

use Doctrine\Common\Collections\Collection;
use Symfony\Component\Serializer\Normalizer\NormalizerInterface;
use Symfony\Component\Serializer\Normalizer\ObjectNormalizer;

use function is_object;

/**
 * Class CollectionNormalizer
 *
 * @package App\General
 */
class CollectionNormalizer implements NormalizerInterface
{
    public function __construct(
        private readonly ObjectNormalizer $normalizer,
    ) {
    }

    /**
     * {@inheritdoc}
     *
     * @return array<int, mixed>
     */
    public function normalize(mixed $object, ?string $format = null, array $context = []): array
    {
        $output = [];

        foreach ($object as $value) {
            $output[] = $this->normalizer->normalize($value, $format, $context);
        }

        return $output;
    }

    /**
     * {@inheritdoc}
     *
     * @param array<string, mixed> $context
     */
    public function supportsNormalization(mixed $data, ?string $format = null, array $context = []): bool
    {
        return $format === 'json' && $data instanceof Collection && is_object($data->first());
    }
}
