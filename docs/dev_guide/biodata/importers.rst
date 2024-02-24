Creating a Chado Data Importer
==============================
Often we want to provide a user interface by which a site developer can easily import data into Chado. Examples of existing loaders compatible with Tripal include the FASTA and GFF3 loaders that come with the Tripal Genome module.  These loaders allow users to import data into Chado that are in `FASTA <https://en.wikipedia.org/wiki/FASTA_format>`_ or `GFF3 format <https://github.com/The-Sequence-Ontology/Specifications/blob/master/gff3.md>`_.  

If you would like to create a new data importer for Chado you will need to create your own **TripalImporter** plugin.  The Tripal importers use the `Drupal Plugin API <https://www.drupal.org/docs/drupal-apis/plugin-api/plugin-api-overview>`_. The plugin infrastructure of Drupal allows a module to provide new functionality that builds off of a common interface. For importing data this interface is provided by the ``TripalImporterInterface`` class.   The **TripalImporter** plugin provides many conveniences. For example, it provides an input form that automatically handles files uploads, it performs job submission, logging, and provides progress updates during execution. Adding a **TripalImporter** plugin to your module will allow anyone who installs your module to also use your new loader!

Here, we will show how to create a **TripalImporter** plugin by building a simple importer called the **ExampleImporter**. This importer reads a comma-separated file containing genomic features and their properties (a fictional "Test Format" file).  The loader will split each line into feature and property values, and then insert each property into the ``featureprop`` table of Chado using a controlled vocabulary term (supplied by the user) as the ``type_id`` for the property.

.. note::
  Prior to starting your data loader you should plan how the data will be imported into Chado. Chado is a flexible database schema and it may be challenging at times to decide in to which tables data should be placed.  It is recommended to reach out to the Chado community to solicit advice. Doing so will allow you to share your loader will other Tripal users more easily!


Step 1: Create Your Module
--------------------------
To create your an importer, you first need to have a Drupal module in which the loader will be provided.  If you do not know how to create a module, see the section titled :doc:`../module_dev` for further direction. For this document we will describe creation of an importer in a fake module named ``tripal_example_importer``.

Step 2: Create the Importer Class File
--------------------------------------
To define a new ``TripalImporter`` plugin, you should first create the directory ``src/Plugin/TripalImporter/`` in your module. For the example here, we will create a new plugin named ``ExampleImporter``. We must name the file the same as the class (with a ``.php`` extension) and place the file in the ``src/Plugin/TripalImporter/`` directory we just created. For example: ``tripal_example_importer\src\Plugin\TripalImporter\ExampleImporter.inc``.    Placing the importer class file in the ``src/Plugin/TripalImporter`` directory is all you need for Tripal to find it. Tripal will automatically place a link for your importer on the Drupal site at **admin > Tripal > Data Loaders**.

Step 3: Stub the Class File
---------------------------

In the Class file created in the previous step we will write our **TripalImporter** plugin. First, we must set the namespace for this class. It should look similar to the path where the file is stored (but without the ``src`` directory):

.. code-block:: php

  <?php
  namespace Drupal\tripal_example_importer\Plugin\TripalImporter;

Next, an importer that is meant to load data into Chado should extend the  ``ChadoImporterBase`` class. 

.. code-block:: php

  <?php
  namespace Drupal\tripal_example_importer\Plugin\TripalImporter;

  use Drupal\tripal_chado\TripalImporter\ChadoImporterBase;

  class ExampleImporter extends ChadoImporterBase {


All **TripalImporter** plugins uss the ``TripalImporterInterface`` which requires that several unctions are included in your plugin. These functions are:

- ``form()``
- ``formSubmit()``
- ``formValidate()``
- ``run()``
- ``postRun()``

We will discuss each fucntion later but for now, we will create "stubs" for each of these functions in our class. For our example empty class it should look like the following:

.. code-block:: php

  <?php
  namespace Drupal\tripal_example_importer\Plugin\TripalImporter;

  use Drupal\tripal_chado\TripalImporter\ChadoImporterBase;

  class ExampleImporter extends ChadoImporterBase {

  
    /**
     * @see ChadoImporterBase::form()
     */
    public function form($form, &$form_state) {

      // Always call the parent form.
      $form = parent::form($form, $form_state);

      return $form;
    }

    /**
     * @see ChadoImporterBase::formSubmit()
     */
    public function formSubmit($form, &$form_state) {
    
    }

    /**
     * @see ChadoImporterBase::formValidate()
     */

    public function formValidate($form, &$form_state) {
    
    }

    /**
     * @see ChadoImporterBase::run()
     */
    public function run() {
    
    }

    /**
     * @see ChadoImporterBase::postRun()
     */
    public function postRun() {
    
    }
  }

Notice in the ``form()`` function there is a call to the ``parent::form()``:

.. code-block:: php

    /**
     * @see ChadoImporterBase::form()
     */
    public function form($form, &$form_state) {

      // Always call the parent form.
      $form = parent::form($form, $form_state);

      return $form;
    }

Without calling the ``parent::form()`` function your importer's form may not properly work.  This is required.

Step 4: Add Class Annotations
-----------------------------
All Drupal plugins require an `Annotation section <https://www.drupal.org/docs/drupal-apis/plugin-api/annotations-based-plugins>`_ that appears as a PHP comment just above the Class definition. The annotation section provides settings that the **TripalImporter** plugin requires.  As a quick example here is the Annotation section for the GFF3 importer. The GFF3 importer is provided by the Tripal Genome module and imports features defined in a GFF3 file into Chado.

.. code-block:: php

  /**
  *  GFF3 Importer implementation of the ChadoImporterBase.
  *
  *  @TripalImporter(
  *    id = "chado_fasta_loader",
  *    label = @Translation("Chado FASTA File Loader"),
  *    description = @Translation("Import a FASTA file into Chado"),
  *    file_types = {"fasta","txt","fa","aa","pep","nuc","faa","fna"},
  *    upload_description = @Translation("Please provide a plain text file following the <a target='_blank' href='https://en.wikipedia.org/wiki/FASTA_format'>FASTA format specification</a>."),
  *    upload_title = @Translation("FASTA File"),
  *    use_analysis = True,
  *    require_analysis = True,
  *    use_button = True,
  *    button_text = @Translation("Import FASTA file"),
  *    file_upload = True,
  *    file_remote = True,
  *    file_local = True,
  *    file_required = True,
  *    submit_disabled = False
  *  )
  */
  class GFF3Importer extends ChadoImporterBase {

In the code above, the annotation section consists of multiple settings in key/value pairs.  The meaning of each settings is as follows:

- ``id``: A unique machine readable plugin ID for the loader. It must only contain alphanumeric characters and the underscore. It should be lowercase.  
- ``label``: the human readable name (or label) for this importer. It is wrapped in a ``@Translation()`` function which will allow Drupal to provide translations for it.  This label is shown to the user in the list of available data importers.
- ``description``: A short description for the site user that briefly indicates what this loader is for. It too is wrapped in a ``@Translation()``  function.  This description is shown to the user for the loader.
- ``file_types``: A list of file extensions that the importer will allow to be uploaded. If a file does not have an extension in the list then it cannot be uploaded by the importer.
- ``upload_title``:  Provides the title that should appear above the upload button.  This helps the user understand what type of file is expected.
- ``upload_description``: Provides the information for the user related to the file upload. You can provide additional instructions or help text.
- ``use_analysis``:  To support FAIR data principles, we should ensure that provenance of data is available. Chado provides the ``analysis`` table to link data to an analysis.  The analysis record provides the details for how the data in the file was created or obtained. Set this to ``False`` if the loader should not require an analysis when loading. if ``use_analysis`` is set to ``True`` then the user will be presented with a form element to select an analysis and this analysis will be available to you for your importer.
- ``require_analysis``:  If the ``use_analysis`` value is set then this value indicates if the analysis should be required. If ``True`` it will be required, otherwise it will be optional.
- ``button_text``: The text that should appear on the button at the bottom of the importer form.
- ``use_button``: Indicates whether a submit button should be present. This should only be ``False`` in situations were you need multiple buttons or greater control over the submit process (e.g., multi-page forms).
- ``submit_disabled``: Indicates whether the submit button should be disabled when the form appears. The form can then be programmatically enabled via AJAX once certain criteria is set.
- ``file_upload``: Indicates if the loader should provide a form element for uploading a file.
- ``file_remote``: Indicates if the loader should provide a form element for specifying the URL of a remote file.
- ``file_local``: Indicates if the loader should provide a form element for specifying the path available to the web server where the file is located.
- ``file_required``:  Indicates if the file must be provided. 

For our ``ExampleImporter`` class we will set the annotations accordingly:

.. code-block:: php

  /**
    *  TST Importer implementation of the ChadoImporterBase.
    *
    *  @TripalImporter(
    *    id = "tripal_tst_loader",
    *    label = @Translation("Example TST File Importer"),
    *    description = @Translation("Loads TST files"),
    *    file_types = {"txt", "tst", "csv"},
    *    upload_description = @Translation("TST is a fictional format.  Its a 2-column, CSV file.  The columns should be of the form featurename, and text"),
    *    upload_title = @Translation("TST File"),
    *    use_analysis = True,
    *    require_analysis = True,
    *    use_button = True,
    *    button_text = @Translation("Import TST file"),
    *    file_upload = True,
    *    file_remote = True,
    *    file_local = True,
    *    file_required = True,
    *    submit_disabled = False
    *  )
    */
    class ExampleImporter extends ChadoImporterBase {

.. warning::

  You must use double quotes when specifying strings in the Annotations.

Step 5: Check Availability
--------------------------
Now that we have created the plugin and set it's annotations it should appear in the list of Tripal Importers at **admin > Tripal > Data Loaders** after we clear the Drupal cache (``drush cr``). 

.. image:: ./custom_data_loader.0.png

.. note::

  If your importer does not show in the list of data loaders, check the Drupal recent logs at **admin > Manage > Reports > Recent log messages** .

Using the annotation settings we provided, the importer form will automatically provide a **File Upload** field set, and an **Analysis** selector.  The **File Upload** section lets users choose to upload a file, provide a server path to a file already on the web server or a specify a remote path for files located via a downloadable link on the web.  The **Analysis** selector is important because it allows the user to specify an analysis that describes how the data file was created. It will look like the following screenshot:

.. image:: custom_data_loader.1.png

Step 6: Customize the Form
--------------------------

Most likely, you will want to add elements the importer form. For our example TST file importer we want to split the file to retrieve feature and their properties, and then insert properties into the ``featureprop`` table of Chado. That table requires a controlled vocabulary term ID for the ``type_id`` column of the table. Therefore, we want to customize the importer form to request a controlled vocabulary term. To customize the form we can use three functions:

- ``form()``:  Allows you to add additional form elements to the form.
- ``formValidate()``:  Provides a mechanism by which you can validate the form elements you added.
- ``formSubmit()``: Allows you to perform some preprocessing prior to submission of the form. Typically this function does not need to be implemented--only if you want to do preprocessing before submission.

.. note::

  If you are not familiar with form creation in Drupal you may want to find a Drupal reference book that provides step-by-step instructions.  Additionally, you can explore the `API documentation for form construction for Drupal 10 <https://www.drupal.org/docs/drupal-apis/form-api>`_.  


The form() function
^^^^^^^^^^^^^^^^^^^

We can use the ``form()`` function to add the element to request the property CV term. To help, Tripal provides a handy service for searching for a controlled vocabulary term, we can use this as part of a text box with an autocomplete.  The following code shows the addition of a new ``textfield`` form element with a ``#autocomplete_route_name`` setting that tells the form to use Tripal's CV search service to support autocompletion as the user types.

.. code-block:: php
  :name: ExampleImporter::form

  public function form($form, &$form_state) {

    // Always call the parent form.
    $form = parent::form($form, $form_state);

    // Add an element to the form to allow a user to pick
    // a controlled vocabulary term.
    $form['pick_cvterm'] = [
      '#title' => t('Property Type'),
      '#type' => 'textfield',
      '#required' => TRUE,
      '#description' => t("Specify the controlled vocabulary term for "
        . "properties that will be added to genomic features in the input file."),
      '#autocomplete_route_name' => 'tripal_chado.cvterm_autocomplete',
      '#autocomplete_route_parameters' => ['count' => 5, 'cv_id' => 0],
    ];

    return $form;
  }

The ``#autocomplete_route_parameters`` setting takes an array of two arguments: ``count`` and ``cv_id``.  The ``count`` argument specifies the maximum number of matching CV terms that will be shown as the user types.  The ``cv_id`` in the example is set to zero, indicating that there are no restrictions on which vocabulary the terms can come from. If you wanted to restrict the user to only selecting terms from a specific vocabulary then you would set the ``cv_id`` to the vocabulary ID from Chado.

Reloading the importer, the form now has an autocomplete text box for selecting a CV term.

.. image:: custom_data_loader.2.png


The formValidate() function
^^^^^^^^^^^^^^^^^^^^^^^^^^^
The ``formValidate()`` function is responsible for verifying that the user supplied values are valid.  This function receives two arguments: ``$form`` and ``$form_validate``.  The ``$form`` object contains the fully built form.  The ``$form_validate`` argument contains the object that represents the user submitted state of the form. To warn the user of inappropriate values, the ``$form_state->setErrorByName()`` function is used. It provides an error message, highlights in red the widget containing the bad value, and prevents the form from being submitted--allowing the user to make corrections. In our example code, we will check that the user selected a CV term from the ``pick_cvterm`` widget.


.. code-block:: php

  public function formValidate($form, &$form_state) {

    // Get the values submitted by the user.
    $form_state_values = $form_state->getValues();

    // The pick_cvterm element is required and Drupal will handle that
    // check for us, so we only need to make sure the user let the user selected
    // a term from the autocomplete with the accession in parentheses.
    $term = $form_state_values['pick_cvterm'];

    if (!preg_match('/\(.+?:.+?\)/', $term)) {
      $form_state->setErrorByName('pick_cvterm',
        t('Please choose a property type from the list that appears while typing. '
          . 'It must include the controlled vocabulary term accession'));
    }
  }

The implementation above gets the ``pick_cvterm`` element from the ``$form_state`` object. The PHP ``preg_match`` function uses a regular expression to make sure the term selected by the user has the format provided by the autocomplete (e.g., `comment (rdfs:comment)`). It checks to make sure the term accession is present in parentheses. For your importer, use this function to check as many form elements as you add to the importer.

The formSubmit() function
^^^^^^^^^^^^^^^^^^^^^^^^^
If you need to perform any steps prior to running the importer you can use the ``formSubmit()`` function.  Suppose we wanted to add to our form the ability for a user to add new terms that do not already exist in the database.  We would create the form elements in the ``form()`` function, make sure we have validation checks in the ``formValidate()`` and then we could insert the new term into the database prior to job submission in the ``formSubmit()`` function.  Most likely you will not need to use this function. For most existing importers provided by Tripal this function is not used.


Step 7:  Write Importing Code
-----------------------------
When an importer form is submitted and passes all validation checks, a job is automatically added to the :doc:`../../admin_guide/jobs`  system. The ``TripalImporter`` parent class does this for us! The :doc:`../../admin_guide/jobs` system is meant to allow long-running jobs to execute behind-the-scenes on a regular time schedule.  As jobs are added they are executed in order.  Therefore, if a user submits a job using the importer's form then the :doc:`../../admin_guide/jobs`  system will automatically run the job the next time it is scheduled to run or it can be launched manually by the site administrator.

When the **Tripal Job** system executes an importer job it will call three different functions:

- ``run()``: contains the code that performs the import of the file.
- ``preRun()``: contains code to be executed prior to the the ``run()`` function.
- ``postRun()``: contains code to be executed after executiong of the ``run()` function.

These functions were added to our class as "stubs" in Step 3 above and now we discuss each of these.

The preRun() function
^^^^^^^^^^^^^^^^^^^^^
The ``preRun()`` function is called automatically by Tripal and should contain code that must be executed prior to running hte importer.  This function provide any setup that is needed prior to importing the file.  In the case of our example importer, we will not need to use the ``preRun()`` function so it will remain empty.

The run() function
^^^^^^^^^^^^^^^^^^
The ``run()`` function is called automatically when Tripal runs the importer. For our ``ExampleImporter``, the run function should read and parse the input file and load the data into Chado. The first step, is to retrieve the user provided values from the form and the file details. The inline comments in the code below provide instructions for retrieving these details.


.. code-block:: php

    public function run() {

      // All values provided by the user in the Importer's form widgets are
      // made available to us here by the Class' arguments member variable.
      $arguments = $this->arguments['run_args'];

      // The path to the uploaded file is always made available using the
      // 'files' argument. The importer can support multiple files, therefore
      // this is an array of files, where each has a 'file_path' key specifying
      // where the file is located on the server.
      $file_path = $this->arguments['files'][0]['file_path'];

      // The analysis that the data being imported is associated with is always
      // provided as an argument.
      $analysis_id = $arguments['analysis_id'];

      // Convert the cvterm text provided by the user submitted form
      // to the actual cvterm ID from chado.
      $cvterm = $arguments['pick_cvterm'];
      $cv_autocomplete = new ChadoCVTermAutocompleteController();
      $cvterm_id = $cv_autocomplete->getCVtermId($cvterm);

      // Now that we have our file path, analysis_id and CV term we can load
      // the file.  We'll do so by creating a new function in our class
      // called "loadMyFile" and pass these arguments to it.
      $this->loadMyFile($analysis_id, $file_path, $cvterm_id);
    }

In the example code above the ``loadMyFile()`` function is a function we add to our importer class that completes the loading of the file.  We do not show the code of that function here, but it will be responsible for reading in the file provided by the ``$file_path`` variable and import the feature properties into Chado. 

Logging 
^^^^^^^
During execution of our importer it is often useful to inform the user of progress, status and issues encountered. All **TripalImporter** plugins have several built-in objects and functions that support logging and reporting of progress.  For logging, each importer has access to a **TripalLogger** accessible as ``$this->logger`` which uses the `Drupal Logging API <https://www.drupal.org/docs/8/api/logging-api/overview>`_.   There are several functions that you can use with the logger than can report errors, warnings, notices or debugging information.  A quick list of these are:

- ``$this->logger->emergency($message)``
- ``$this->logger->alert($message)``
- ``$this->logger->critical($message)``
- ``$this->logger->error($message)``
- ``$this->logger->warning($message)``
- ``$this->logger->notice($message)``
- ``$this->logger->info($message)``
- ``$this->logger->debug($message)``

For each of the functions above, the ``$message`` argument should contain the text that is reported. The following is an example code from the GFF3 loader where logging is used to report progress of each step:

.. code-block:: php

  $this->logger->notice("Step  1 of 27: Caching GFF3 file...");
  

.. note::

  Do not use ``print`` or ``print_r`` statements as a way to inform the user of warnings, errors or progress. 


Throwing errors
^^^^^^^^^^^^^^^
The **TripalImporter** plugins can throw errors if needed.  Tripal will catch the error, perform appropriate logging and recover gracefully.  An example of throwing an error from the GFF3 loader:

.. code-block:: php

    throw new \Exception(t('Cannot find landmark feature type \'%landmark_type\'.',
         ['%landmark_type' => $this->default_landmark_type]));

After an error is caught by Tripal, all database changes will be rolled back and any changes made to the database during the process of running the importer will no longer exist. 

Reporting Progress
^^^^^^^^^^^^^^^^^^
For progress reporting, each importer can utilze two different functions:

- ``$this->setTotalItems()``: Indicates the total number of items (or steps) that must be processed for the laoder to complete.
- ``$this->setItemsHandled()``: Reports the total number of items that have been handled.




The setTotalItems and setItemsHandled functions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The ``TripalImporter`` class is capable of providing progress updates to the end-user while the importer job is running. This is useful as it gives the end-user a sense for how long the job will take. As shown in the sample code above for the ``loadMyFile`` function, The first step is to tell the ``TripalImporter`` how many items need processing.  An **item** is an arbitrary term indicating some measure of countable "units" that will be processed by our importer.

In the code above we consider a byte as an item, and when all bytes from a file are read we are done loading that file.  Therefore the ``setTotalItems`` function is used to tell the importer how many bytes we need to process.  As we read each line, we count the number of bytes read and provide that number to the ``setItemsHandled`` function.  The ``TripalImporter`` class will automatically calculate progress and print a message to the end-user indicating the percent complete, and some additional details such as the total amount of memory consumed during the loading.

.. note::

  All importers are different and the "item" need not be the number of bytes in the file.  However, if you want to provide progress reports you must identify an "item" and the total number of items there are for processing.

Testing Importers
------------------
Unit Testing is a critically important component of any software project. You should always strive to write tests for your software.  Tripal provides unit testing using the ``phpunit`` testing framework. The Tripal Test Suite provides a strategy for adding tests for your new Importer.  It will automatically set up and bootstrap Drupal and Tripal for your testing environment, as well as provide database transactions for your tests, and factories to quickly generate data.  We will use the Tripal Test Suite to provide unit testing for our ``ExampleImporter``.

.. note::
  Before continuing, please install and configure Tripal Test Suite.

  For instructions on how to install, configure, and run Tripal Test Suite, `please see the Tripal Test Suite documentation. <https://tripaltestsuite.readthedocs.io/en/latest/>`_


Example file
^^^^^^^^^^^^
When developing tests, consider including a small example file as this is good practice both to ensure that your loader works as intended, and for new developers to easily see the expected file format.  For our ``ExampleImporter``, we'll include the following sample file and store it in this directory of our module:  ``tests/data/example.txt``.

.. csv-table:: Example input file
  :header: "Feature name", "CVterm value"

  "test_gene_1", "blue"
  "test_gene_2", "red"


Loading the Importer
^^^^^^^^^^^^^^^^^^^^
Testing your loader requires a few setup steps.  First, TripalImporters are not explicitly loaded in your module (note that we never use ``include_once()`` or ``require_once`` in the ``.module`` file).  Normally Tripal finds the importer automatically, but for unit testing we must include it to our test class explicitly.  Second, we must initialize an instance of our importer class. Afterwards we can perform any tests to ensure our loader executed properly.  The following function provides an example for setup of the loader for testing:

.. code-block:: php

  private function run_loader(){

    // Load our importer into scope.
    module_load_include('inc', 'tripal_example_importer', 'includes/TripalImporter/ExampleImporter');

    // Create an array of arguments we'll use for testing our importer.
    $run_args = [
      'analysis_id' => $some_analysis_id,
      'cvterm' => $some_cvterm_id
    ];
    $file = ['file_local' => __DIR__ . '/../data/exampleFile.txt'];

    // Create a new instance of our importer.
    $importer = new \ExampleImporter();
    $importer->create($run_args, $file);

    // Before we run our loader we must let the TripalImporter prepare the
    // files for us.
    $importer->prepareFiles();
    $importer->run();
  }

.. note::

  We highly recommend you make use of database transactions in your tests, especially when running loaders.  Simply add ``use DBTransaction;`` at the start of your test class.  Please see the `Tripal Test Suite documentation for more information <https://tripaltestsuite.readthedocs.io/en/latest/>`_.