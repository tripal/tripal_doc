
Chado Dbxref Buddy
====================

This buddy has the instance name ``chado_dbxref_buddy`` and the class name ``ChadoDbxrefBuddy``.

This is the simplest buddy since it handles just two chado tables,
the ``db`` and ``dbxref`` tables.

It provides nine functions:

  .. table:: Chado Dbxref Buddy:

    +------------------+--------------+----------------+
    | Function         | db table     | dbxref table   |
    +==================+==============+================+
    | Lookup           | :ref:`getDb()` | getDbxref()    |
    +------------------+--------------+----------------+
    | Insert           | insertDb()   | insertDbxref() |
    +------------------+--------------+----------------+
    | Update           | updateDb()   | updateDbxref() |
    +------------------+--------------+----------------+
    | Upsert           | upsertDb()   | upsertDbxref() |
    +------------------+--------------+----------------+
    | Associate        |              | getDbxref()    |
    +------------------+--------------+----------------+
    | Helper           |              | getDbxrefUrl() |
    +------------------+--------------+----------------+



getDb
^^^^^^^

Retrieves records from the chado ``db`` table.

Usage: ``$records = $instance->getDb($conditions, $options);``

Valid keys for $conditions:

* db.db_id
* db.name
* db.description
* db.url
* db.urlprefix

Valid settings for $options:

  'case_insensitive' => key
  'case_insensitive' => [key1, key2];



insertDb
^^^^^^^^^^

Inserts a new record into the chado ``db`` table.

Usage: ``$records = $instance->insertDb($values, $options);``

Valid keys for $conditions:

* db.name
* db.description
* db.url
* db.urlprefix

Required keys to insert a new record:

* db.name

