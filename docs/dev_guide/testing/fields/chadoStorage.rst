
Testing Chado Field storage
=============================

As described in the documentation for how to create fields, Chado Fields depend on the developer to define a number of properties in order to describe to ChadoStorage how to create, load and update the various biological data associated with that field. For example, when creating a field to describe the organism associated with a gene, you will define properties for the genus, species, intraspecific type, infraspecific name, etc. Then ChadoStorage will use the property definitions to pull these data out of Chado and make them available to your field. In this tutorial, we are focusing on testing that the properties you defined in your field, act as you expect and that ChadoStorage is understanding your intent properly.

.. warning::

  All the following will assume you are developing these tests using the TripalDocker, with your module fully installed and mounted within the docker. For instructions on how to set this up see :doc:`Install with TripalDocker </install/docker>` documentation. In all the commands with CONTAINERNAME, replace it with the name of your container.

Creating your testing Class
-----------------------------

All tests are encapsulate within their own class as dictated by PHPunit. As such lets create a class skeleton as follows:

In `[yourmodule]/tests/src/Kernel/Plugin/ChadoStorage` create a file with a descriptive name for your test. We recommend naming it using the following pattern `[FieldName]Test.php`. The "Test" suffix is required by PHPUnit so make sure to at least include that in your test name or the test runner will not be able to find your test.

Here is a basic skeleton that you can copy/paste and replace the `TOKENS` with information for your own field:


.. code-block:: php

  <?php

  namespace Drupal\Tests\tripal_chado\Kernel\Plugin\ChadoStorage;

  use Drupal\Tests\tripal_chado\Kernel\ChadoTestKernelBase;
  use Drupal\Tests\tripal_chado\Traits\ChadoStorageTestTrait;

  use Drupal\tripal\TripalStorage\StoragePropertyValue;
  use Drupal\tripal\TripalStorage\StoragePropertyTypeBase;

  /**
  * Tests that ChadoStorage can handle property fields as we expect.
  * The array of fields/properties used for these tests are designed
  * to match those in the FIELDNAME field with values filled
  * based on a CONTENTTYPE_VALID_FOR_THIS_FIELD content type.
  *
  * Note: We do not need to test invalid conditions for createValues() and
  * updateValues() as these are only called after the entity has validated
  * the system using validateValues(). Instead we test all invalid conditions
  * are caught by validateValues().
  *
  * Specific test cases:
  *  - TEST CASE DESCRIPTION
  *
  * @group YOURMODULE
  * @group ChadoStorage
  */
  class FIELDNAMETest extends ChadoTestKernelBase {

    use ChadoStorageTestTrait;

    protected $fields = [];

    /**
     * {@inheritdoc}
     */
    protected function setUp() :void {
      parent::setUp();
      $this->setUpChadoStorageTestEnviro();

      // Any code needed to setup the environment for your tests.
    }

    /**
     * DESCRIBE YOUR TEST CASE HERE IN PLAIN ENGLISH.
     */
    public function testNAMEOFTESTCASE() {

      // PHPUnit complains if any test doesn't assert something.
      // We will just assert a basic fact here to confirm our test class is
      // setup properly.
      $this->assertTrue(TRUE);
    }
  }

Now we will run our specific test in order to confirm that it is setup properly:

.. code-block:: bash

  docker exec --workdir=/var/www/drupal9/web/modules/contrib/YOURMODULE \
    CONTAINERNAME phpunit tests/src/Kernel/Plugin/ChadoStorage/FIELDNAMETest.php

This will only run the tests in the test file we just setup. If you see errors regarding missing classes, then check that you have the `use` statements for those classes. If no test is found the make sure the class name matches the filename, the classname ends in `Test` and the method name starts with `test`.

I am going to walk you through creating a test for the ChadoOrganismDefault field
in this tutorial so all future code will show that case.

For example, if I were to complete the above instructions to create a `tripal_chado/tests/src/Kernel/Plugin/ChadoStorage/ChadoOrganismDefaultTest.php` file containing the skeleton template above and execute:

.. code-block:: bash

  ❯ docker exec --workdir=/var/www/drupal9/web/modules/contrib/tripal tripal1587 \
    phpunit tripal_chado/tests/src/Kernel/Plugin/ChadoStorage/ChadoOrganismDefaultTest.php

I would get the following output:

::

  PHPUnit 9.6.10 by Sebastian Bergmann and contributors.

  Testing Drupal\Tests\tripal_chado\Kernel\Plugin\ChadoStorage\ChadoOrganismDefaultTest
  .                                                                   1 / 1 (100%)

  Time: 00:05.203, Memory: 10.00 MB

  OK (1 test, 6 assertions)

Designing your `$fields` array
--------------------------------

This is argueably the most important step of writing these tests as the ChadoStorageTestTrait will use this variable repeatedly throughout. You may have noticed this variable assigned as an empty array at the top of the skeleton class we created:

.. code-block:: php
  :emphasize-lines: 5

  class FIELDNAMETest extends ChadoTestKernelBase {

    use ChadoStorageTestTrait;

    protected $fields = [];

    /**
     * {@inheritdoc}
     */
    protected function setUp() :void {
      parent::setUp();
      $this->setUpChadoStorageTestEnviro();

      // Any code needed to setup the environment for your tests.
    }

Each element of this array defines a test field and it's properties. More specifically, it follows this pattern:

.. code-block:: php

  protected $fields = [
    'FIELDNAME' => [
      'field_name' => 'FIELDNAME',
      'base_table' => 'BASE TABLE',
      'properties' => [
        'PROP KEY' => [
          'propertyType class' => 'FULL NAMESPACE + CLASS NAME',
          ... STORAGE SETTINGS ...
        ],
      ],
    ],
  ];

Where the FIELNAME here does not need to match the name of the field you are testing. Rather it is an identifier for a group of properties being tested together. For example, for testing the ChadoOrganismDefault field, we may want 3 fields defined in this array labelled `gene_ChadoOrganismDefault`, `germplasm_ChadoOrganismDefault`, and `library_ChadoOrganismDefault` to indicate the 3 content types we want to test on. The base table of each would then be `feature`, `stock`, and `library` respectively and these values would be carried down into the properties.

The properties array should match exactly with the properties added in your field `addTypes()` method. For each item returned by that method you should have an element in this array. Here is an example comparing the property defined in addTypes() with the same property within the test $fields array:

.. code-block:: php
  :caption: addTypes()
  :linenos:
  :emphasize-lines: 1,4,8,9,10

  $properties[] =  new ChadoVarCharStoragePropertyType(
    $entity_type_id,
    self::$id,
    'genus',
    $genus_term,
    $genus_len,
    [
      'action' => 'join',
      'path' => $base_table . '.organism_id>organism.organism_id',
      'chado_column' => 'genus'
    ]
  );

.. code-block:: php
  :caption: test $fields array
  :linenos:

  'genus' => [
    'propertyType class' => 'Drupal\tripal_chado\TripalStorage\ChadoVarCharStoragePropertyType',
    'action' => 'join',
    'path' => 'feature' . '.organism_id>organism.organism_id',
    'chado_column' => 'genus'
  ],

As you can see, the class name in the highlighted line 1 maps to the propertyType class in the fields array. The highlighted property key `genus` on line 4 becomes the array key in the fields array. Finally highlighted lines 8-10 indicate the storage settings and are copied directly into the fields array.

For example, if you are testing the ChadoOrganismDefault field on a gene content type your complete fields array would look like:

.. code-block:: php
  :linenos:

  protected $fields = [
    'gene_ChadoOrganismDefault' => [
      'field_name' => 'ChadoOrganismDefault',
      'base_table' => 'feature',
      'properties' => [
        'record_id' => [
          'propertyType class' => 'Drupal\tripal_chado\TripalStorage\ChadoIntStoragePropertyType',
          'action' => 'store_id',
          'drupal_store' => TRUE,
          'chado_table' => 'feature',
          'chado_column' => 'feature_id',
        ],
        'organism_id' => [
          'propertyType class' => 'Drupal\tripal_chado\TripalStorage\ChadoIntStoragePropertyType',
          'action' => 'store',
          'chado_table' => 'feature',
          'chado_column' => 'organism_id',
        ],
        'label' => [
          'propertyType class' => 'Drupal\tripal_chado\TripalStorage\ChadoVarCharStoragePropertyType',
          'action' => 'replace',
          'template' => "<i>[genus] [species]</i> [infraspecific_type] [infraspecific_name]",
        ],
        'genus'=> [
          'propertyType class' => 'Drupal\tripal_chado\TripalStorage\ChadoVarCharStoragePropertyType',
          'action' => 'join',
          'path' => 'feature' . '.organism_id>organism.organism_id',
          'chado_column' => 'genus'
        ],
        'species' => [
          'propertyType class' => 'Drupal\tripal_chado\TripalStorage\ChadoVarCharStoragePropertyType',
          'action' => 'join',
          'path' => 'feature' . '.organism_id>organism.organism_id',
          'chado_column' => 'species'
        ],
        'infraspecific_name' => [
          'propertyType class' => 'Drupal\tripal_chado\TripalStorage\ChadoVarCharStoragePropertyType',
          'action' => 'join',
          'path' => 'feature' . '.organism_id>organism.organism_id',
          'chado_column' => 'infraspecific_name',
        ],
        'infraspecific_type' => [
          'propertyType class' => 'Drupal\tripal_chado\TripalStorage\ChadoIntStoragePropertyType',
          'action' => 'join',
          'path' => 'feature' . '.organism_id>organism.organism_id;organism.type_id>cvterm.cvterm_id',
          'chado_column' => 'name',
          'as' => 'infraspecific_type_name'
        ],
      ],
    ],
    'gene_allOtherPropertiesNeeded' => [
      'field_name' => 'gene_allOtherPropertiesNeeded',
      'base_table' => 'feature',
      'properties' => [
        'record_id' => [
          'propertyType class' => 'Drupal\tripal_chado\TripalStorage\ChadoIntStoragePropertyType',
          'action' => 'store_id',
          'chado_table' => 'feature',
          'chado_column' => 'feature_id'
        ],
        'feature_type' => [
          'propertyType class' => 'Drupal\tripal_chado\TripalStorage\ChadoIntStoragePropertyType',
          'action' => 'store',
          'chado_table' => 'feature',
          'chado_column' => 'type_id'
        ],
        'feature_organism' => [
          'propertyType class' => 'Drupal\tripal_chado\TripalStorage\ChadoIntStoragePropertyType',
          'action' => 'store',
          'chado_table' => 'feature',
          'chado_column' => 'organism_id'
        ],
        'feature_uname' => [
          'propertyType class' => 'Drupal\tripal_chado\TripalStorage\ChadoVarCharStoragePropertyType',
          'action' => 'store',
          'chado_table' => 'feature',
          'chado_column' => 'uniquename'
        ],
      ],
    ],
  ];

You may have noticed on line 51 in the above codeblock a second field. This is a catchall field for the properties associated with the remaining columns in the feature table required to create a new record. This is only needed if your field has a widget which is allowed to edit the entity.
