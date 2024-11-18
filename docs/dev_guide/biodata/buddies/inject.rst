Injecting the Buddy Service
=============================

A typical use case for a Chado Buddy is in an importer.
Best practice is to inject the buddy service into your importer class.
Let's see how that is done.

First you will need to include these classes in your importer:

.. code::

  use Drupal\Core\Plugin\ContainerFactoryPluginInterface;
  use Symfony\Component\DependencyInjection\ContainerInterface;
  use Drupal\tripal_chado\ChadoBuddy\PluginManagers\ChadoBuddyPluginManager;
  use Drupal\tripal_chado\Plugin\ChadoBuddy\‎ChadoDbxrefBuddy;
  use Drupal\tripal_chado\Plugin\ChadoBuddy\‎ChadoCvtermBuddy;
  use Drupal\tripal_chado\Plugin\ChadoBuddy\‎ChadoPropertyBuddy;

Then you will need to implement ``ContainerFactoryPluginInterface`` in your class. For example:

.. code::

  abstract class MyImporter extends ChadoImporterBase implements ContainerFactoryPluginInterface {

Next add a class variable to store the buddy service, and whichever buddy instance or instances you will need.

.. code::

  /**
   * The Chado Buddy service manager
   *
   * @var Drupal\tripal_chado\ChadoBuddy\PluginManagers\ChadoBuddyPluginManager
   */
  protected ChadoBuddyPluginManager $buddy_manager;

  /**
   * An instance of the dbxref Chado Buddy.
   *
   * @var Drupal\tripal_chado\Plugin\ChadoBuddy\‎ChadoDbxrefBuddy
   */
  protected ‎ChadoDbxrefBuddy $dbxref_instance;

  /**
   * An instance of the cvterm Chado Buddy.
   *
   * @var Drupal\tripal_chado\Plugin\ChadoBuddy\‎ChadoCvtermBuddy
   */
  protected ‎ChadoCvtermBuddy $cvterm_instance;

  /**
   * An instance of the property Chado Buddy.
   *
   * @var Drupal\tripal_chado\Plugin\ChadoBuddy\‎ChadoPropertyBuddy
   */
  protected ‎ChadoPropertyBuddy $property_instance;


You will need to add a ``create()`` function to your class. An example of this, where
we inject both the chado database and chado buddy:

.. code::

  /**
   * Implements ContainerFactoryPluginInterface->create().
   *
   * We are injecting an additional dependency here beyond what
   * the ChadoImporterBase class has, i.e. the ChadoBuddyPluginManager.
   *
   * Since we have implemented the ContainerFactoryPluginInterface this static function
   * will be called behind the scenes when a Plugin Manager uses createInstance(). Specifically,
   * this method is used to determine the parameters to pass to the contructor.
   *
   * @param \Symfony\Component\DependencyInjection\ContainerInterface $container
   * @param array $configuration
   * @param string $plugin_id
   * @param mixed $plugin_definition
   *
   * @return static
   */
  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('tripal_chado.database'),
      $container->get('tripal_chado.chado_buddy')
    );
  }

Next we add a ``__construct()`` function, or if you already have one, add similar code to it. For example:

.. code::

  /**
   * {@inheritdoc}
   */
  public function __construct(array $configuration, $plugin_id, $plugin_definition,
                              ChadoConnection $connection, ChadoBuddyPluginManager $buddy_manager) {
    parent::__construct($configuration, $plugin_id, $plugin_definition, $connection);
    $this->buddy_manager = $buddy_manager;
    $this->dbxref_instance = $this->buddy_manager->createInstance('chado_dbxref_buddy', []);
    $this->cvterm_instance = $this->buddy_manager->createInstance('chado_cvterm_buddy', []);
    $this->property_instance = $this->buddy_manager->createInstance('chado_property_buddy', []);
  }

That's all there is to it! Now whenever you need to call a buddy function the instance(s)
will be there and initialized! For example:

.. code::

  $chado_buddy_records = $this->cvterm_instance->getCv('cv.name' => 'local');
