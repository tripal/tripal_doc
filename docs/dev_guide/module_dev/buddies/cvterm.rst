
Chado Cvterm Buddy
====================

This buddy has the class name ``ChadoCvtermBuddy`` and the instance name ``chado_cvterm_buddy``.

This buddy deals with four chado tables,
the ``db``, ``dbxref``, ``cv``, and ``cvterm`` tables.

This buddy provides the following functions:

  .. table:: Chado Cvterm Buddy:

    +------------------+-------------------+--------------------------+------------------------------+
    | Type of          |                   |                          |                              |
    | Function         | cv table          | cvterm table             | cvtermsynonym synonym        |
    +==================+===================+==========================+==============================+
    | Lookup           | :ref:`getCv()`    | :ref:`getCvterm()`       | :ref:`getCvtermSynonym()`    |
    +------------------+-------------------+--------------------------+------------------------------+
    | Insert           | :ref:`insertCv()` | :ref:`insertCvterm()`    | :ref:`insertCvtermSynonym()` |
    +------------------+-------------------+--------------------------+------------------------------+
    | Update           | :ref:`updateCv()` | :ref:`updateCvterm()`    | :ref:`updateCvtermSynonym()` |
    +------------------+-------------------+--------------------------+------------------------------+
    | Upsert           | :ref:`upsertCv()` | :ref:`upsertCvterm()`    | :ref:`upsertCvtermSynonym()` |
    +------------------+-------------------+--------------------------+------------------------------+
    | Associate        |                   | :ref:`associateCvterm()` |                              |
    +------------------+-------------------+--------------------------+------------------------------+



getCv()
^^^^^^^^^

Retrieves one or more records from the chado `cv <https://laceysanderson.github.io/chado-docs/cv/tables/cv.html>`_ table.

Usage: ``$chado_buddy_records = $cvterm_instance->getCv($conditions, $options);``

Valid keys for ``$conditions``:

* ``cv.cv_id``
* ``cv.name``
* ``cv.definition``
* ``buddy_record``

Valid settings for ``$options``:

* ``'case_insensitive' => key`` or ``'case_insensitive' => [key1, key2, ...]``
  Any keys specified here will be queried without case sensitivity. For example

  ``$cvterm_instance->getCv(['cv.name' => 'edam'], ['case_insensitive' => 'cv.name']);``

  will return either 'edam' or 'EDAM' or both.



insertCv()
^^^^^^^^^^^^

Inserts a new record into the chado `cv <https://laceysanderson.github.io/chado-docs/cv/tables/cv.html>`_ table.

Usage: ``$chado_buddy_records = $cvterm_instance->insertCv($values, $options);``

Valid keys for ``$values``:

* ``cv.name``
* ``cv.definition``
* ``buddy_record``

Required keys to insert a new record:

* ``cv.name``



updateCv()
^^^^^^^^^^^^

Updates an existing record in the chado `cv <https://laceysanderson.github.io/chado-docs/cv/tables/cv.html>`_ table.

Usage: ``$chado_buddy_records = $cvterm_instance->updateCv($values, $conditions, $options);``

Valid keys for ``$values`` and ``$conditions``:

* ``cv.name``
* ``cv.definition``
* ``buddy_record``

Valid keys for ``$conditions`` only:

* ``cv.cv_id``



upsertCv()
^^^^^^^^^^^^

Updates a record if it exists, or inserts it if it does not, in the chado `cv <https://laceysanderson.github.io/chado-docs/cv/tables/cv.html>`_ table.
Only keys designated with a Ⓠ are used for the query to find the record to update if it already exists.

Usage: ``$chado_buddy_records = $cvterm_instance->insertCv($values, $options);``

Valid keys for ``$values``:

* ``cv.name`` Ⓠ
* ``cv.definition``
* ``buddy_record``

Required keys to upsert a new record:

* ``cv.name``



getCvterm()
^^^^^^^^^^^^^

Retrieves one or more records from the chado `cvterm <https://laceysanderson.github.io/chado-docs/cv/tables/cvterm.html>`_ table.

Usage: ``$chado_buddy_records = $cvterm_instance->getCvterm($conditions, $options);``

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
* ``buddy_record``

Valid settings for ``$options``:

* ``'case_insensitive' => key`` or ``'case_insensitive' => [key1, key2, ...]``
  Any keys specified here will be queried without case sensitivity, e.g. 'edam' == 'EDAM'



insertCvterm()
^^^^^^^^^^^^^^^^

Inserts a new record into the chado `cvterm <https://laceysanderson.github.io/chado-docs/cv/tables/cvterm.html>`_ table.

Usage: ``$chado_buddy_records = $cvterm_instance->insertCvterm($values, $options);``

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
* ``buddy_record``

Required keys to insert a new record:

* either ``db.db_id`` or ``dbxref.db_id`` or ``db.name``
* either ``dbxref.dbxref_id`` or ``cvterm.dbxref_id`` or ``dbxref.accession``
* either ``cv.cv_id`` or ``cvterm.cv_id`` or ``cv.name``
* ``cvterm.name``



updateCvterm()
^^^^^^^^^^^^^^^^

Updates an existing record in the chado `cvterm <https://laceysanderson.github.io/chado-docs/cv/tables/cvterm.html>`_ table.

Usage: ``$chado_buddy_records = $cvterm_instance->updateCvterm($values, $conditions, $options);``

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

 * ``create_dbxref`` - set to FALSE (default TRUE) if you do not
   want to automatically create a dbxref if one does not already exist.


upsertCvterm()
^^^^^^^^^^^^^^^^

Updates a record if it exists, or inserts it if it does not, in the chado `cvterm <https://laceysanderson.github.io/chado-docs/cv/tables/cvterm.html>`_ table.
Only keys designated with a Ⓠ are used for the query to find the record to update if it already exists.

Usage: ``$chado_buddy_records = $cvterm_instance->insertCvterm($values, $options);``

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
* ``buddy_record``

Required keys to upsert a new record:

* either ``db.db_id`` or ``dbxref.db_id`` or ``db.name``
* either ``dbxref.dbxref_id`` or ``cvterm.dbxref_id`` or ``dbxref.accession``
* either ``cv.cv_id`` or ``cvterm.cv_id`` or ``cv.name``
* ``cvterm.name``



associateCvterm()
^^^^^^^^^^^^^^^^^^^

Given an existing dbxref record, associate it with a record in a chado table using its linking table.
Both the cvterm and the chado record indicated by $record_id must already exist.

Usage: ``$boolean_result = $cvterm_instance->associateCvterm($base_table, $record_id, $cvterm, $options);``

Parameter string ``$base_table`` is the base table for which the dbxref should be associated.
For example, to associate a dbxref with a feature the base_table=``feature`` and dbxref_id is added to the
``feature_dbxref`` table.

Parameter integer ``$record_id`` is the primary key of the base_table to associate the dbxref with.

Parameter ChadoBuddyRecord ``$cvterm`` is a record returned by one of the ``xxxCvterm()`` functions.

Valid keys for ``$options``:

* ``pkey`` Looking up the primary key for the base table is costly. If it is
  known, then pass it in as this option for better performance.
* Also pass in any other columns used in the linking table. Sometimes there is a NOT NULL
  constraint, so a value is required.

This function returns TRUE if successful.
