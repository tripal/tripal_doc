
Chado Property Buddy
======================

This buddy has the class name ``ChadoPropertyBuddy`` and the instance name ``chado_property_buddy``.

This buddy deals with five chado tables, the
`db <https://laceysanderson.github.io/chado-docs/db/tables/db.html>`_,
`dbxref <https://laceysanderson.github.io/chado-docs/db/tables/dbxref.html>`_,
`cv <https://laceysanderson.github.io/chado-docs/cv/tables/cv.html>`_,
`cvterm <https://laceysanderson.github.io/chado-docs/cv/tables/cvterm.html>`_,
and "linker" tables.
The linker table by convention is the name of the specified base table plus ``prop``.
For example, for the ``project`` table it is ``projectprop``.

This buddy provides the following functions:

  .. table:: Chado Cvterm Buddy:

    +------------------+-------------------------+
    | Type of          |                         |
    | Function         | "linker" table          |
    +==================+=========================+
    | Lookup           | :ref:`getProperty()`    |
    +------------------+-------------------------+
    | Insert           | :ref:`insertProperty()` |
    +------------------+-------------------------+
    | Update           | :ref:`updateProperty()` |
    +------------------+-------------------------+
    | Upsert           | :ref:`upsertProperty()` |
    +------------------+-------------------------+
    | Delete           | :ref:`deleteProperty()` |
    +------------------+-------------------------+



getProperty()
^^^^^^^^^^^^^^^

Retrieves zero or more records from the linker table,
and returns an array of ChadoBuddyRecord records.

Usage: ``$chado_buddy_records = $property_instance->getProperty($base_table, $record_id, $conditions, $options);``

Parameter string ``$base_table`` is the base table for which the property should be associated.
For example, to associate a property with a feature the base_table=``feature`` and property is added to the
``featureprop`` table.

Parameter integer ``$record_id`` is the primary key of the base_table to associate the dbxref with.

Valid keys for ``$conditions``:

* ``db.db_id``
* ``db.name``
* ``db.description``
* ``db.url``
* ``db.urlprefix``
* ``dbxref.dbxref_id``
* ``dbxref.db_id``
* ``dbxref.description``
* ``dbxref.accession``
* ``dbxref.version``
* ``cv.cv_id``
* ``cv.name``
* ``cv.definition``
* ``cvterm.cvterm_id``
* ``cvterm.cv_id``
* ``cvterm.name``
* ``cvterm.definition``
* ``cvterm.dbxref_id``
* ``cvterm.is_obsolete``
* ``cvterm.is_relationshiptype``
* linker.linker ``_id``
* linker ``.type_id``
* linker ``.value``
* (other columns that may be in the linker table)
* ``buddy_record``

Valid settings for ``$options``:

* ``property_table`` the name of the chado property table, if the default needs to be changed.
  Normally this is $base_table . 'prop'.
* ``pkey`` the name of the primary key for the property table, if the default needs to be changed.
  Normally this is $base_table . '_id'.
* ``fkey`` the name of the foreign key for the property table, if the default needs to be changed.
  Normally this is property_table . '_id'.
* ``'case_insensitive' => key`` or ``'case_insensitive' => [key1, key2, ...]``
  Any keys specified here will be queried without case sensitivity, e.g. 'edam' == 'EDAM'



insertProperty()
^^^^^^^^^^^^^^^^^^

Inserts a new record into the chado linker table,
and returns a ChadoBuddyRecord describing the inserted record.

Usage: ``$chado_buddy_record = $property_instance->insertProperty($base_table, $record_id, $values, $options);``

Valid keys for ``$values``:

* ``db.db_id``
* ``db.name``
* ``db.description``
* ``db.url``
* ``db.urlprefix``
* ``dbxref.dbxref_id``
* ``dbxref.db_id``
* ``dbxref.description``
* ``dbxref.accession``
* ``dbxref.version``
* ``cv.cv_id``
* ``cv.name``
* ``cv.definition``
* ``cvterm.cvterm_id``
* ``cvterm.cv_id``
* ``cvterm.name``
* ``cvterm.definition``
* ``cvterm.dbxref_id``
* ``cvterm.is_obsolete``
* ``cvterm.is_relationshiptype``
* linker.linker ``_id``
* linker ``.type_id``
* linker ``.value``
* (other columns that may be in the linker table)
* ``buddy_record``

Required keys to insert a new record:

* either ``cvterm.cvterm_id`` or linker ``.type_id``
* linker ``.value``



updateProperty()
^^^^^^^^^^^^^^^^^^

Updates an existing record in the chado linker table,
and returns a ChadoBuddyRecord describing the updated record.

Usage: ``$chado_buddy_record = $property_instance->updateProperty($base_table, $record_id, $values, $conditions, $options);``

Valid keys for ``$values`` and ``$conditions``:

* ``dbxref.description``
* ``dbxref.accession``
* ``dbxref.version``
* ``cvterm.cv_id``
* ``cvterm.name``
* ``cvterm.definition``
* ``cvterm.dbxref_id``
* ``cvterm.is_obsolete``
* ``cvterm.is_relationshiptype``
* linker.linker ``_id``
* linker ``.type_id``
* linker ``.value``
* (other columns that may be in the linker table)
* ``buddy_record``

Valid keys for ``$conditions`` only:

* ``db.db_id``
* ``db.name``
* ``db.description``
* ``db.url``
* ``db.urlprefix``
* ``dbxref.dbxref_id``
* ``dbxref.db_id``
* ``cv.cv_id``
* ``cv.name``
* ``cv.definition``
* ``cvterm.cvterm_id``

Valid keys for ``$options``:

 * ``create_cvterm`` - set to TRUE (default FALSE) if you want to
   automatically create a dbxref and cvterm if one does not already exist.



upsertProperty()
^^^^^^^^^^^^^^^^^^

Updates a record if it exists, or inserts it if it does not, in the chado linker table,
and returns a ChadoBuddyRecord describing the updated record.
Only keys designated with a Ⓠ are used for the query to find the record to update if it already exists.

Usage: ``$chado_buddy_record = $property_instance->insertProperty($base_table, $record_id, $values, $options);``

Valid keys for ``$values``:

* ``db.db_id``
* ``db.name`` Ⓠ
* ``db.description``
* ``db.url``
* ``db.urlprefix``
* ``dbxref.db_id`` Ⓠ
* ``dbxref.description``
* ``dbxref.accession`` Ⓠ
* ``dbxref.version`` Ⓠ
* ``cv.cv_id``
* ``cv.name`` Ⓠ
* ``cv.definition``
* ``cvterm.cv_id`` Ⓠ
* ``cvterm.name`` Ⓠ
* ``cvterm.definition``
* ``cvterm.dbxref_id`` Ⓠ
* ``cvterm.is_obsolete`` Ⓠ
* ``cvterm.is_relationshiptype``
* linker ``.type_id`` Ⓠ
* linker ``.value``
* (other columns that may be in the linker table)
* ``buddy_record``

Required keys to upsert a new record:

* either ``db.db_id`` or ``dbxref.db_id`` or ``db.name``
* either ``dbxref.dbxref_id`` or ``cvterm.dbxref_id`` or ``dbxref.accession``
* either ``cv.cv_id`` or ``cvterm.cv_id`` or ``cv.name``
* ``cvterm.cvterm_id`` or ``cvterm.name``



deleteProperty()
^^^^^^^^^^^^^^^^^^

Deletes one or more records in the chado linker table.

Usage: ``$number_deleted = $property_instance->getProperty($base_table, $record_id, $conditions, $options);``

Use the same parameters as described above for :ref:`getProperty()`

Returns a count of how many properties were actually deleted.

Additional valid key for ``$options``:

* ``max_delete`` - This by default is ``1``. If more records than this number would
  be deleted, an exception is thrown. Set to ``-1`` to disable this limit.
