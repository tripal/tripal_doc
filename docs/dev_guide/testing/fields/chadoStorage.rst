
Testing Chado Field storage
=============================

.. warning::
  This documentation is still under development and is not complete.

As described in the documentation for how to create fields, Chado Fields depend on the developer to define a number of properties in order to describe to ChadoStorage how to create, load and update the various biological data associated with that field. For example, when creating a field to describe the organism associated with a gene, you will define properties for the genus, species, infraspecific type, infraspecific name, etc. Then ChadoStorage will use the property definitions to pull these data out of Chado and make them available to your field. In this tutorial, we are focusing on testing that the properties you defined in your field, act as you expect and that ChadoStorage is understanding your intent properly.

.. warning::

  All the following will assume you are developing these tests using the TripalDocker, with your module fully installed and mounted within the docker. For instructions on how to set this up see :doc:`Install with TripalDocker </install/docker>` documentation. In all the commands with CONTAINERNAME, replace it with the name of your container.

Creating your testing Class
-----------------------------

All tests are encapsulated within their own class as dictated by PHPunit. As such lets create a class skeleton as follows:

In `[yourmodule]/tests/src/Kernel/Plugin/ChadoStorage` create a file with a descriptive name for your test. We recommend naming it using the following pattern `[FieldName]Test.php`. The "Test" suffix is required by PHPUnit so make sure to at least include that in your test name or the test runner will not be able to find your test.

Here is a basic skeleton that you can copy/paste and replace the `TOKENS` with information for your own field:

.. code-block:: php

  <?php

  namespace Drupal\Tests\YOURMODULE\Kernel\Plugin\ChadoStorage;

  use Drupal\Tests\tripal_chado\Kernel\ChadoTestKernelBase;
  use Drupal\Tests\tripal_chado\Traits\ChadoStorageTestTrait;
  use Drupal\Tests\tripal_chado\Functional\MockClass\FieldConfigMock;

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
  * @group Fields
  * @group ChadoStorage
  */
  class FIELDNAMETest extends ChadoTestKernelBase {

    use ChadoStorageTestTrait;

    // We will populate this variable at the start of each test
    // with fields specific to that test.
    protected $fields = [];

    protected $yaml_file = __DIR__ . "/FIELDNAME-FieldDefinitions.yml";


    /**
     * {@inheritdoc}
     */
    protected function setUp() :void {
      parent::setUp();
      $this->setUpChadoStorageTestEnviro();

      $this->setFieldsFromYaml($this->yaml_file, "testNAMEOFTESTCASE");
      $this->cleanChadoStorageValues();

      // Any code needed to setup the environment for your tests.
      // For example, you may need to insert records into the test chado
      // here if your field links to existing records.

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

This will only run the tests in the test file we just setup. If you see errors regarding missing classes, then check that you have the `use` statements for those classes. If no test is found then make sure the class name matches the filename, the classname ends in `Test`, and the method name starts with `test`.

I am going to walk you through creating a test for the ChadoContactDefault field
in this tutorial so all future code will show that case. You can see the finished test we are creating in the `tripal/tripal Github repository: tripal_chado/tests/src/Kernel/Plugin/ChadoStorage/ChadoContactDefaultTest.php file <https://github.com/tripal/tripal/blob/4.x/tripal_chado/tests/src/Kernel/Plugin/ChadoStorage/ChadoContactDefaultTest.php>`_.

For example, if I were to complete the above instructions to create a `tripal_chado/tests/src/Kernel/Plugin/ChadoStorage/ChadoContactDefaultTest.php` file containing the skeleton template above and execute:

.. code-block:: bash

  ❯ docker exec --workdir=/var/www/drupal9/web/modules/contrib/tripal tripal1587 \
    phpunit tripal_chado/tests/src/Kernel/Plugin/ChadoStorage/ChadoContactDefaultTest.php

I would get the following output:

::

  PHPUnit 9.6.10 by Sebastian Bergmann and contributors.

  Testing Drupal\Tests\tripal_chado\Kernel\Plugin\ChadoStorage\ChadoContactDefaultTest
  .                                                                   1 / 1 (100%)

  Time: 00:05.203, Memory: 10.00 MB

  OK (1 test, 6 assertions)

You may find it helpful to include the `--testdox --verbose` parameters to `phpunit` when testing to obtain more verbose output.

Defining the field instances to be tested
------------------------------------------

When a field is attached to a specific content type it is called a field instance. When testing fields, we work primarily with a number of test field instances focused on specific content types.

In this example, the field we are testing relates contacts to many other Tripal content types. While most content types have the same style linking table to the contact table, the arraydesign table has a different format. As such, the decision was made to test one random content type (i.e. study) and the arraydesign content type to capture both linking table variations. This is why in the following field instance definitions, you will see two instances: testContactFieldStudy and testContactFieldArrayDesign. The names do not matter so you might as well be descriptive of their purpose. Just ensure they do not contain spaces or special characters.

Field instances for testing are defined in a specific YAML format:

::

  [test method which will be using the fields i.e. testNAMEOFTESTCASE]:
    [field name]:
      field_name: [field name]
      base_table: [base table]
      properties:
        [property key]:
          propertyType class: [full class name + namespace]
          action: [action]
          [additional key/value pairs associated with the action]

This YAML is stored in its own file in the same directory. In this case that would be `tripal/tripal Github repository: tripal_chado/tests/src/Kernel/Plugin/ChadoStorage/ChadoContactDefault-FieldDefinitions.yml file <https://github.com/tripal/tripal/blob/4.x/tripal_chado/tests/src/Kernel/Plugin/ChadoStorage/ChadoContactDefault-FieldDefinitions.yml>`_ and this file was referred to in the setup function of the test template.

Methods provided by ChadoStorageTestTrait
-------------------------------------------

The following methods are provided by the test trait and can be used to make testing the functionality a lot easier:

- `$this->chadoStorageTestInsertValues($insert_values)`: attempts to insert the values in the parameter for the specific field.
- `$retrieved_values = $this->chadoStorageTestLoadValues($load_values)`: attempts to load the remaining values specified by the few keys provided as parameters. ChadoStorage is given the values of all properties with drupal_store being TRUE by Drupal itself so those keys are passed in here when testing. The retrieved values are StoragePropertyValue objects so you need to use `getValue()` on them to retrieve the value loaded.
- `$this->chadoStorageTestUpdateValues($update_values)`: attempts to update the values of existing chado records to match the changes in the parameter.

You can see more details about how these are used to test in the finished `ChadoContactDefaultTest <https://github.com/tripal/tripal/blob/4.x/tripal_chado/tests/src/Kernel/Plugin/ChadoStorage/ChadoContactDefaultTest.php>`_ test. There are also a number of additional examples of this testing in the same directory.
