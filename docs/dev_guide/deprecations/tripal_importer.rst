
## Tripal importer core services not being injected is deprecated in favour of injecting them.

- **Deprecated in** {tripal 4.0.0-alpha3}
- **Removed in** {tripal 4.0.0}
- **Issue** `#2056 <https://github.com/tripal/tripal/issues/2056>`_
- **PR** `#2221 <https://github.com/tripal/tripal/pull/2221>`_

Coding best practice is to inject dependencies into classes. In this case, several services
were used in tripal importers, but were created inside the class at various points.
Updating the importer base class `__construct()` methods to inject these services involved
adding new parameters. To maintain backward compatibility, the new parameters are optional,
and if NULL, then the service is created inside the `__construct()` method, but a deprecation
message is generated with a link that leads to this page. When version 4.0.0 is released,
these parameters will be required.

TripalImporterBase __construct()
--------------------------------

If your importer does not override the `__construct()` method, no changes are needed.
If it does because you are injecting one or more additional services, you now need to include the additional core services.

**Before:**

.. code-block:: php

  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('your_module.additional_service'),
    );
  }

  public function __construct(
    array $configuration,
    $plugin_id,
    $plugin_definition,
    SomeAdditionalService $additional_service,
  ) {
    parent::__construct(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $connection,
    );
    $this->additional_service = $additional_service;
  }

**After:**

.. code-block:: php

  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('your_module.additional_service'),
      $container->get('messenger'),
      $container->get('tripal.logger'),
      $container->get('tripal.fileretriever'),
      $container->get('tripal.backend_publish'),
    );
  }

  public function __construct(
    array $configuration,
    $plugin_id,
    $plugin_definition,
    SomeAdditionalService $additional_service,
    Messenger $messenger,
    TripalLogger $logger,
    TripalFileRetriever $fileretriever,
    TripalBackendPublishManager $publish_manager,
  ) {
    parent::__construct(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $messenger,
      $logger,
      $fileretriever,
      $publish_manager,
    );
    $this->additional_service = $additional_service;
  }

ChadoImporterBase __construct()
--------------------------------

If your importer does not override the `__construct()` method, no changes are needed.
If it does because you are injecting one or more additional services, you now need to include the additional core services.

**Before:**

.. code-block:: php

  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('tripal_chado.database'),
      $container->get('your_module.additional_service'),
    );
  }

  public function __construct(
    array $configuration,
    $plugin_id,
    $plugin_definition,
    ChadoConnection $connection,
    SomeAdditionalService $additional_service,
  ) {
    parent::__construct(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $connection,
    );
    $this->additional_service = $additional_service;
  }

**After:**

.. code-block:: php

  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('your_module.additional_service'),
      $container->get('tripal_chado.database'),
      $container->get('messenger'),
      $container->get('tripal.logger'),
      $container->get('tripal.fileretriever'),
      $container->get('tripal.backend_publish'),
    );
  }

  public function __construct(
    array $configuration,
    $plugin_id,
    $plugin_definition,
    SomeAdditionalService $additional_service,
    ChadoConnection $connection,
    Messenger $messenger,
    TripalLogger $logger,
    TripalFileRetriever $fileretriever,
    TripalBackendPublishManager $publish_manager,
  ) {
    parent::__construct(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $connection,
      $messenger,
      $logger,
      $fileretriever,
      $publish_manager,
    );
    $this->additional_service = $additional_service;
  }
