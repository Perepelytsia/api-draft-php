<?php

declare(strict_types=1);

namespace App\General\Transport\Rest\Traits\Actions\Logged;

use App\General\Transport\Rest\Traits\Methods\FindMethod;
use App\Role\Domain\Entity\Role;
use OpenApi\Annotations as OA;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\IsGranted;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Throwable;

/**
 * Trait FindAction
 *
 * Trait to add 'findAction' for REST controllers for 'ROLE_LOGGED' users.
 *
 * @see \App\General\Transport\Rest\Traits\Methods\FindMethod for detailed documents.
 *
 * @package App\General
 */
trait FindAction
{
    use FindMethod;

    /**
     * Get list of entities, accessible only for 'ROLE_LOGGED' users.
     *
     * @OA\Response(
     *     response=200,
     *     description="success",
     *     @OA\JsonContent(
     *         type="array",
     *         @OA\Items(type="string"),
     *     ),
     * )
     * @OA\Response(
     *     response=403,
     *     description="Access denied",
     *     @OA\JsonContent(
     *         type="object",
     *         example={"code": 403, "message": "Access denied"},
     *         @OA\Property(property="code", type="integer", description="Error code"),
     *         @OA\Property(property="message", type="string", description="Error description"),
     *     ),
     * )
     *
     * @throws Throwable
     */
    #[Route(
        path: '',
        methods: [Request::METHOD_GET],
    )]
    #[IsGranted(Role::ROLE_LOGGED)]
    public function findAction(Request $request): Response
    {
        return $this->findMethod($request);
    }
}
