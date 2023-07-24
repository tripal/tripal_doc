
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

