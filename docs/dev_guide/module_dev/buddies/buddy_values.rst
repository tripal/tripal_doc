Buddy Parameters
==================

Chado Buddy Input Values
--------------------------

Values are passed to a buddy function through an associative array.
The keys for this array are the chado table name and the table column name separated by a period.
For example, for the table ``db`` and column ``name``, the key would be ``db.name``.
This method prevents ambiguity when a buddy handles more than one table, and different tables
may have the same column name, such as ``db.name`` and ``cv.name``.

Any or all input values can be also be passed in using a ChadoBuddyRecord, using the key
`buddy_record` in the values array.

Chado Buddy Output Values
---------------------------

Depending on the function, most of the chado buddy functions will return one or more objects of the class ``ChadoBuddyRecord``.
An object of this class provides two functions to retrieve values:

  1. ``$chado_buddy_record->getValues()`` - this function returns an associative array in the same format
     as was used to pass input data.
  2. ``$chado_buddy_record->getValue($key, $options)`` - this function returns a single value from the record.
     By default, if the passed key does not exist, an exception is thrown.
     This strict mode can be disabled and a NULL will be returned instead.
     Enable this lenient mode with:

     ``$options = ['strict' => FALSE]``

.. note::

  For insert and update functions, the function will return a single object of the ``ChadoBuddyRecord`` class.

  For query functions, the function will return an array of ``ChadoBuddyRecord`` records. This array will be
  empty if no records matched the input values, and can have one or more records if matches were found.

Chado Buddy Example #1
------------------------

Here is a simple example to look up the ``db_id`` value of the ``local`` database record.

.. code::

  $buddy_service = \Drupal::service('tripal_chado.chado_buddy');
  $dbxref_instance = $buddy_service->createInstance('chado_dbxref_buddy', []);

  $chado_buddy_records = $dbxref_instance->getDb(['db.name' => 'local'], []);
  $db_id = NULL;
  if ($chado_buddy_records) {
    $db_id = $chado_buddy_records[0]->getValue('db.db_id');
    print "local db id=$db_id\n";
  }

Chado Buddy Example #2
------------------------

Here is a more advanced example of creating a new controlled vocabulary term,
including a dbxref, and using that term to assign a property to a gene.

.. code::

  $buddy_service = \Drupal::service('tripal_chado.chado_buddy');
  $cvterm_instance = $buddy_service->createInstance('chado_cvterm_buddy', []);
  $property_instance = $buddy_service->createInstance('chado_property_buddy', []);

  // Create the cvterm and dbxref records in chado, unless they already exist.
  $values = [
    'db.name' => 'local',
    'cv.name' => 'local',
    'dbxref.accession' => 'X000002',
    'cvterm.name' => 'Example 2',
    'cvterm.definition' => 'A fake ontology term for example #2',
  ];
  $chado_cvterm_record = $cvterm_instance->upsertCvterm($values, []);
  // if for any reason insert failed, an exception is thrown, so
  // you should catch exceptions as shown in example #3
  $cvterm_id = $chado_cvterm_record->getValue('cvterm.cvterm_id');
  print "Created or found cvterm with id=$cvterm_id\n";

  // Create the property record in the featureprop table
  $feature_id = 1; // For this example a gene feature exists with this id
  $values = [
    'buddy_record' => $chado_cvterm_record,
    'featureprop.value' => 'Example value of 2 for the property',
  ];
  $chado_property_record = $property_instance->upsertProperty('feature', $feature_id, $values, []);
  $featureprop_id = $chado_property_record->getValue('featureprop.featureprop_id');
  print "Added property with id=$featureprop_id\n";

Chado Buddy Example #3
------------------------

This is the same as example #2, but we enable a mode where we can create the
cvterm and dbxref automatically if it does not already exist, as long as we
have all the values required to do so. In addition, we catch any exceptions
that may occur so we can handle them appropriately, for example, the database
or CV names we supplied might not exist.

.. code::

  $buddy_service = \Drupal::service('tripal_chado.chado_buddy');
  $property_instance = $buddy_service->createInstance('chado_property_buddy', []);

  $values = [
    'db.name' => 'local',
    'cv.name' => 'local',
    'dbxref.accession' => 'X000003',
    'cvterm.name' => 'Example 3',
    'cvterm.definition' => 'A fake ontology term for example #3',
    'featureprop.value' => 'Example value of 3 for the property',
  ];
  $options = [
    'create_cvterm' => TRUE,
  ];
  $feature_id = 1; // For this example a gene feature exists with this id
  try {
    $chado_property_record = $property_instance->upsertProperty('feature', $feature_id, $values, $options);
  }
  catch (\Exception $e) {
    print $e->getMessage();
  }
  $featureprop_id = $chado_property_record->getValue('featureprop.featureprop_id');
  print "Added property with id=$featureprop_id\n";
