
Chado Dbxref Buddy
====================

This buddy has the class name ``ChadoDbxrefBuddy`` and the instance name ``chado_dbxref_buddy``.

This is the simplest buddy since it handles just two chado tables, the
`db <https://laceysanderson.github.io/chado-docs/db/tables/db.html>`_
and `dbxref <https://laceysanderson.github.io/chado-docs/db/tables/dbxref.html>`_ tables.

This buddy provides the following functions:

  .. table:: Chado Dbxref Buddy:

    +------------------+-------------------+--------------------------+
    | Type of          |                   |                          |
    | Function         | db table          | dbxref table             |
    +==================+===================+==========================+
    | Lookup           | :ref:`getDb()`    | :ref:`getDbxref()`       |
    +------------------+-------------------+--------------------------+
    | Insert           | :ref:`insertDb()` | :ref:`insertDbxref()`    |
    +------------------+-------------------+--------------------------+
    | Update           | :ref:`updateDb()` | :ref:`updateDbxref()`    |
    +------------------+-------------------+--------------------------+
    | Upsert           | :ref:`upsertDb()` | :ref:`upsertDbxref()`    |
    +------------------+-------------------+--------------------------+
    | Associate        |                   | :ref:`associateDbxref()` |
    +------------------+-------------------+--------------------------+
    | Helper           |                   | :ref:`getDbxrefUrl()`    |
    +------------------+-------------------+--------------------------+



getDb()
^^^^^^^^^

Retrieves one or more records from the chado `db <https://laceysanderson.github.io/chado-docs/db/tables/db.html>`_ table.

Usage: ``$chado_buddy_records = $dbxref_instance->getDb($conditions, $options);``

Valid keys for ``$conditions``:

* ``db.db_id``
* ``db.name``
* ``db.description``
* ``db.url``
* ``db.urlprefix``
* ``buddy_record``

Valid settings for ``$options``:

* ``'case_insensitive' => key`` or ``'case_insensitive' => [key1, key2, ...]``
  Any keys specified here will be queried without case sensitivity. For example

  ``$dbxref_instance->getDb(['db.name' => 'edam'], ['case_insensitive' => 'db.name']);``

  will return either 'edam' or 'EDAM' or both.



insertDb()
^^^^^^^^^^^^

Inserts a new record into the chado `db <https://laceysanderson.github.io/chado-docs/db/tables/db.html>`_ table.

Usage: ``$chado_buddy_records = $dbxref_instance->insertDb($values, $options);``

Valid keys for ``$values``:

* ``db.name``
* ``db.description``
* ``db.url``
* ``db.urlprefix``
* ``buddy_record``

Required keys to insert a new record:

* ``db.name``



updateDb()
^^^^^^^^^^^^

Updates an existing record in the chado `db <https://laceysanderson.github.io/chado-docs/db/tables/db.html>`_ table.

Usage: ``$chado_buddy_records = $dbxref_instance->updateDb($values, $conditions, $options);``

Valid keys for ``$values`` and ``$conditions``:

* ``db.name``
* ``db.description``
* ``db.url``
* ``db.urlprefix``
* ``buddy_record``

Valid keys for ``$conditions`` only:

* ``db.db_id``



upsertDb()
^^^^^^^^^^^^

Updates a record if it exists, or inserts it if it does not, in the chado `db <https://laceysanderson.github.io/chado-docs/db/tables/db.html>`_ table.
Only keys designated with a Ⓠ are used for the query to find the record to update if it already exists.

Usage: ``$chado_buddy_records = $dbxref_instance->insertDb($values, $options);``

Valid keys for ``$values``:

* ``db.name`` Ⓠ
* ``db.description``
* ``db.url``
* ``db.urlprefix``
* ``buddy_record``

Required keys to upsert a new record:

* ``db.name``



getDbxref()
^^^^^^^^^^^^^

Retrieves one or more records from the chado `dbxref <https://laceysanderson.github.io/chado-docs/db/tables/dbxref.html>`_ table.

Usage: ``$chado_buddy_records = $dbxref_instance->getDbxref($conditions, $options);``

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
* ``buddy_record``

Valid settings for ``$options``:

* ``'case_insensitive' => key`` or ``'case_insensitive' => [key1, key2, ...]``
  Any keys specified here will be queried without case sensitivity, e.g. 'edam' == 'EDAM'



insertDbxref()
^^^^^^^^^^^^^^^^

Inserts a new record into the chado `dbxref <https://laceysanderson.github.io/chado-docs/db/tables/dbxref.html>`_ table.

Usage: ``$chado_buddy_records = $dbxref_instance->insertDbxref($values, $options);``

Valid keys for ``$values``:

* ``db.name``
* ``db.description``
* ``db.url``
* ``db.urlprefix``
* ``dbxref.dbxref_id``
* ``dbxref.db_id``
* ``dbxref.description``
* ``dbxref.accession``
* ``dbxref.version``
* ``buddy_record``

Required keys to insert a new record:

* either ``db.db_id`` or ``dbxref.db_id`` or ``db.name``
* ``dbxref.accession``



updateDbxref()
^^^^^^^^^^^^^^^^

Updates an existing record in the chado `dbxref <https://laceysanderson.github.io/chado-docs/db/tables/dbxref.html>`_ table.

Usage: ``$chado_buddy_records = $dbxref_instance->updateDbxref($values, $conditions, $options);``

Valid keys for ``$values`` and ``$conditions``:

* ``dbxref.db_id``
* ``dbxref.description``
* ``dbxref.accession``
* ``dbxref.version``
* ``buddy_record``

Valid keys for ``$conditions`` only:

* ``db.db_id``
* ``db.name``
* ``db.description``
* ``db.url``
* ``db.urlprefix``
* ``dbxref.dbxref_id``



upsertDbxref()
^^^^^^^^^^^^^^^^

Updates a record if it exists, or inserts it if it does not, in the chado `dbxref <https://laceysanderson.github.io/chado-docs/db/tables/dbxref.html>`_ table.
Only keys designated with a Ⓠ are used for the query to find the record to update if it already exists.

Usage: ``$chado_buddy_records = $dbxref_instance->insertDbxref($values, $options);``

Valid keys for ``$values``:

* ``db.name`` Ⓠ
* ``db.description``
* ``db.url``
* ``db.urlprefix``
* ``dbxref.db_id`` Ⓠ
* ``dbxref.description``
* ``dbxref.accession`` Ⓠ
* ``dbxref.version`` Ⓠ
* ``buddy_record``

Required keys to upsert a new record:

* either ``db.db_id`` or ``dbxref.db_id`` or ``db.name``
* ``dbxref.accession``



associateDbxref()
^^^^^^^^^^^^^^^^^^^

Given an existing dbxref record, associate it with a record in a chado table using its linking table.
Both the dbxref and the chado record indicated by $record_id must already exist.

Usage: ``$boolean_result = $dbxref_instance->associateDbxref($base_table, $record_id, $dbxref, $options);``

Parameter string ``$base_table`` is the base table for which the dbxref should be associated.
For example, to associate a dbxref with a feature the base_table=``feature`` and dbxref_id is added to the
``feature_dbxref`` table.

Parameter integer ``$record_id`` is the primary key of the base_table to associate the dbxref with.

Parameter ChadoBuddyRecord ``$dbxref`` is a record returned by one of the ``xxxDbxref()`` or ``xxxCvterm()`` functions.

Valid keys for ``$options``:

* ``pkey`` Looking up the primary key for the base table is costly. If it is
  known, then pass it in as this option for better performance.
* Also pass in any other columns used in the linking table. Sometimes there is a NOT NULL
  constraint, so a value is required.

This function returns TRUE if successful.



getDbxrefUrl()
^^^^^^^^^^^^^^^^

Generates a URL for a database reference (e.g. the reference for a cvterm).
If the URL prefix is provided for the database record of a cvterm,
then a URL can be created for the term. By default, the db name and
dbxref accession are concatenated and appended to the end of the
urlprefix. But Tripal supports the use of {db} and {accession} tokens
in the db.urlprefix string. If present, they will be replaced with the
db name and dbxref accession, respectively.

Usage: ``$url_string = $dbxref_instance->getDbxrefUrl($dbxref, $options);``

Parameter ChadoBuddyRecord ``$dbxref`` is a record returned by one of the ``xxxDbxref()`` or ``xxxCvterm()`` functions.

Valid keys for ``$options``:

* None, here for consistency.

Returns a string containing the URL as described above.
