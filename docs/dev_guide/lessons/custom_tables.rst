How to use Custom Tables in Chado
=================================
This lessons describes how to programmatically create and manage :doc:`../biodata/custom_tables`.

.. warning::
    You should avoid making any changes to existing Chado tables as it could make upgrades to future releases of Chado more difficult and could break functionality in Tripal that expects Chado tabes to be a certain way.


The Custom Table Service
------------------------
Tripal provides a Drupal service for working with Custom tables. The service has the following functions:

- ``create()``:  creates a new ``ChadoCustomTable`` object and in the process creates the custom table in the Chado database.
- ``loadById()``:  if the custom table already exists and the ID is already known, then this function creates a new ``ChadoCustomTable`` object for working with the table.
- ``loadByName()``: if the custom table already exists and the table name is known, then this function creates a new ``ChadoCustomTable`` object for working with the table.
- ``findByName()``: finds the ID of an existing table using the table name.

Creating a Custom Table
-----------------------
To create a new custom table, you must first define the table schema which will include the table columns, constraints, default values, and indexes.  This design must then be written using the the Drupal `Schema API <https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Database%21database.api.php/group/schemaapi/10>`_, which is a PHP associate array with key/value pair that specify the components of the table.  The following provides an example table schema array for a custom ``library_stock`` table that is intended to link recrods in the ``stock`` table of Chado with records in the ``library`` table of Chado:

.. code-block:: php

    [
        'table' => 'library_stock',
        'fields' => [
            'library_stock_id' => [
                'type' => 'serial',
                'not null' => TRUE,
            ],
            'library_id' => [
                'type' => 'int',
                'not null' => TRUE,
            ],
            'stock_id' => [
                'type' => 'int',
                'not null' => TRUE,
            ]
        ],
        'primary key' => [
            'library_stock_id'
        ],
        'unique keys' => [
            'library_stock_c1' => [
            'library_id',
            'stock_id'
            ]
        ],
        'indexes' => [
            'name' => ['library_id', 'stock_id'],
        ],
        'foreign keys' => [
            'library' => [
                'table' => 'library',
                'columns' => [
                    'library_id' => 'library_id'
                ],
            ],
            'stock' => [
                'table' => 'stock',
                'columns' => [
                    'stock_id' => 'stock_id'
                ]
            ]
        ]
    ]

Note that in the array structure above the columns, primary keys, foreign keys, unique keys, and indexes for the table are indicated.

Once the table is defined it can be created by calling the ``create()`` function of the custom table service.

.. code-block:: php

    

The ChadoCustomTable Object
---------------------------
The ``ChadoCustomTable`` provides the functions for working with a single table.  





Deleting a Custom Table
-----------------------

Finding Custom Tables
---------------------

