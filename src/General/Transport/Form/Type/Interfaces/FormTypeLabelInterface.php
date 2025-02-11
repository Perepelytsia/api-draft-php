<?php

declare(strict_types=1);

namespace App\General\Transport\Form\Type\Interfaces;

/**
 * Interface FormTypeLabelInterface
 *
 * @package App\General
 */
interface FormTypeLabelInterface
{
    public const LABEL = 'label';
    public const REQUIRED = 'required';
    public const EMPTY_DATA = 'empty_data';
    public const TYPE = 'type';
    public const FIRST_NAME = 'first_name';
    public const FIRST_OPTIONS = 'first_options';
    public const SECOND_NAME = 'second_name';
    public const SECOND_OPTIONS = 'second_options';
    public const CHOICES = 'choices';
}
