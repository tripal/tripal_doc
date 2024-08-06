
Buddy Parameters
==================

Chado Buddy Input Values
--------------------------

Values are passed to a buddy function through an associative array.
The keys for this array are the chado table name and the table column name separated by a period.
For example, for the table ``db`` and column ``name``, the key would be ``db.name``.
This method prevents ambiguity when a buddy handles more than one table, and different tables
may have the same column name, such as ``db.name`` and ``cv.name``.

Chado Buddy Output Values
---------------------------

Most of the chado buddy functions return objects of the class ``ChadoBuddyRecord``.
This class provides two functions to retrieve values.

  1. ``$chado_buddy_records->getValues()`` - this function returns an associative array in the same format
     as was used to pass input data.
  2. ``$chado_buddy_records->getValue($key)`` - this function returns a single value from the record.
     If the passed key does not exist, a NULL is returned.

.. note::

  A buddy function will return a single object of the ``ChadoBuddyRecord`` class if a single record is returned.

  It will return an array of ``ChadoBuddyRecord`` objects if two or more records are returned.

  It will return ``FALSE`` if no records matched the input values.

The buddy class also provides a counting function for convenience in determining how many records were returned
  ``$buddy_instance->countBuddies($chado_buddy_records)``
which will return an integer indicating how many records were returned.

Chado Buddy Example #1
------------------------

Here is a simple example to look up the ``db_id`` value of the ``local`` database record.

.. code::

  $buddy_service = \Drupal::service('tripal_chado.chado_buddy');
  $dbxref_instance = $buddy_service->createInstance('chado_dbxref_buddy', []);

  $chado_buddy_records = $dbxref_instance->getDb(['db.name' => 'local'], []);
  $db_id = NULL;
  if ($chado_buddy_records) {
    // For demonstration, we can first check if this is an array
    if (is_array($chado_buddy_records)) {
      $db_id = $chado_buddy_records[0]->getValue('db.db_id');
    }
    else {
      $db_id = $chado_buddy_records->getValue('db.db_id');
    }
  }
