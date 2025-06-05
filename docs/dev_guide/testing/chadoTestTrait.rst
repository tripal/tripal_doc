
Chado Testing Environment
==========================

The chado testing environment builds upon the Tripal testing environment. I will describe the chado specific portions in detail below but for more detail on the other steps you should check out the documentation on the :ref:`Tripal Testing Environment`.

1. Drupal sets up the testing environment including it's own database and fully functional site.
2. Tripal does not make any new changes to the environment but the Chado Test bases do. Specifically, they add the chado_installations table to the drupal schema and initialize TripalDBX in the test environment.
3. The code inside your tests `setUp()` method is run. The first thing that should be done in the setup for any test interacting with chado is to intialize the chado database.


  .. code-block:: php

    // Initialize the chado instance with all the records that would be present after running prepare.
    $chado_connection = $this->getTestSchema(ChadoTestBrowserBase::PREPARE_TEST_CHADO);

  The capitalized portion indicates the type of chado to initialize. In the above example, `PREPARE_TEST_CHADO` indicates the resulting chado schema will have all the records that would be present after running prepare. The options available are:

   - `INIT_CHADO_EMPTY`: creates an empty chado schema for testing. All tables are there but no records.
   - `PREPARE_TEST_CHADO`: creates a chado schema with all tables and all records that would be present after running "prepare" through the UI.
   - `INIT_CHADO_DUMMY`: creates a prepared chado schema with everything that PREPARE_TEST_CHADO and with additional test data. You can see the test data here in `tripal_chado/tests/fixtures/fill_chado.sql <https://github.com/tripal/tripal/blob/4.x/tripal_chado/tests/fixtures/fill_chado.sql>`_

   Additionally, in some cases you will want to specify a specific version of chado to install in the test environment. This can be done by passing the version number as the optional second parameter as is shown in the following example.

   .. code-block:: php

    // Initialize an empty chado version 1.3.3.013 instance with no records.
    $chado_connection = $this->getTestSchema(ChadoTestBrowserBase::INIT_CHADO_EMPTY, '1.3.3.013');

4. Finally your test method is called. Note: any services, plugins, etc. that you use here will only have the test environment available. You will not have access to any data in your main site, nor should this long term affect your main site. **That said, we do not recommend running tests on production sites!**
5. Once your test is complete, the `tearDown()`` method is called to clean the entire development environment up. This includes dropping the development drupal tables including any changes made by your test.

Retrieving the cvterm ID of a term in your test chado
-------------------------------------------------------

Often in your setup you will be using Tripal DBX to insert records into your test chado instance. There is a handly function to help you look up the cvterm_id based on the accession:

  .. code-block:: php

    $idspace = 'SO';
    $accession = '0000704';
    $cvterm_id = $this->getCvtermID($idspace, $accession);

The above example retrieves the cvterm_id for the gene term in the test chado database.
