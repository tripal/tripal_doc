How to use Custom Tables in Chado
=================================
This lessons describes how to programmatically create and manage :doc:`../biodata/custom_tables`.

.. warning::
    You should avoid making any changes to existing Chado tables as it could make upgrades to future releases of Chado more difficult and could break functionality in Tripal that expects Chado tabes to be a certain way.


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

Note that in the array structure above, the columns, primary keys, foreign keys, unique keys, and indexes for the table are indicated. 

The table can be created by calling the ``create()`` function of the Triapl Custom Table Service.  To create the ``library_stock`` table  defined in the array above we would use the following:

.. code-block:: php

    // Get an instance of the Custom Table service.
    /** @var \Drupal\tripal_chado\Services\ChadoCustomTableManager $ct_service **/
    $ct_service = \Drupal::service('tripal_chado.custom_tables');

    // Use the servcie to create the table object by providing it a name.
    /** @var \Drupal\tripal_chado\ChadoCustomTables\ChadoCustomTable $custom_table **/
    $custom_table = $cv_service->create('library_stock');

The code above will create an instance of a ``ChadoCustomTable`` object but it does not yet create the table in Chado. To do that you must set the table schema in the following way:

.. code-block:: php

    // Provide the Schema API array defining the table structure.
    $custom_table->setTableSchema($schema);

In the code above, the ``$schema`` variable contains the Schema API array defined above. Calling ``setTableSchema()`` will automatically create the table in the Chado schema and return ``TRUE`` on success.  If there are any errors in the structure of the ``$schema`` array or any problems creating the table, messages will be logged to Drupal, the attempt will fail and the function will return ``FALSE``.

Hiding a Custom Table
---------------------
Tripal will provides to the site developers, an interface by which they can add custom tables. Site developers will also be able to see custom tables in the interface which allows them to delete them, rename them or alter them.  If you are adding a custom table for use by your extension module and you do not want the site administrator to alter it in any way, you can hide the table from the administrator.  Non custom Chado tables are not avaialble for alteration and custom tables that are necessary for the functioning of a module should not be either.

After creation of your custom table, you can hide the table from the site developers by calling the ``setHidden()`` function on the ``ChadoCustomTable`` object and passing ``TRUE`` as the only argument.

.. code-block:: php

    $custom_table->setHidden(TRUE);

The Table ID
------------
Every custom table in Tripal is given a unique ID.  You can retreive this ID using the ``getTableId()`` function of the ``ChadoCustomTable`` object:

.. code-block:: php

    $table_id = $custom_table->getTableId();


Later, you can find the ID of any custom table by calling the ``findByName()`` function of the Tripal Custom Table Service:

.. code-block:: php

    // Get an instance of the Custom Table service.
    /** @var \Drupal\tripal_chado\Services\ChadoCustomTableManager $ct_service **/
    $ct_service = \Drupal::service('tripal_chado.custom_tables');

    $table_id = $ct_service->findByName('library_stock');


Finding Custom Tables
---------------------
After custom tables are created, you will most likely want to work with them in other parts of you module.  You will need to have a ``ChadoCustomTable`` object anytime you want to work with a custom table. There are multiple ways that you can find a table and get a ``ChadoCustomTable`` object for it:  by ID, by name or by iterating through all custom tables. 

Load by ID
~~~~~~~~~~
If you know the ID of the table you can get a ``ChadoCustomTable`` object by calling the ``loadById()`` function the Custom Table Service:

.. code-block:: php

    // Get an instance of the Custom Table service.
    /** @var \Drupal\tripal_chado\Services\ChadoCustomTableManager $ct_service **/
    $ct_service = \Drupal::service('tripal_chado.custom_tables');

    $custom_table = $ct_service->loadById($table_id);

In the code above, the ``$table_id`` argument would store the known ID of the table. The ``$custom_table`` variable is now a ``ChadoCustomTable`` object that can be used to work with the table.

Load by Name
~~~~~~~~~~~~
Custom table names should be unique. So, if you only know the table name, you can get a ``ChadoCustomTable`` object using the ``loadbyName()`` function of the Chado Custom Table Service.  

.. code-block:: php

    // Get an instance of the Custom Table service.
    /** @var \Drupal\tripal_chado\Services\ChadoCustomTableManager $ct_service **/
    $ct_service = \Drupal::service('tripal_chado.custom_tables');

    $custom_table = $ct_service->loadbyName('library_stock');

Getting a List of Custom Tables
-------------------------------
If you need to get a list of existing custom tables, you can retrieve the names and IDs by calling the ``getTables()`` function of the Tripal Custom Tables Service;

.. code-block:: php

    // Get an instance of the Custom Table service.
    /** @var \Drupal\tripal_chado\Services\ChadoCustomTableManager $ct_service **/
    $ct_service = \Drupal::service('tripal_chado.custom_tables');

    $custom_tables = $ct_service->getTables();

In the code above, the ``$custom_tables`` variable will be an associative array where the keys are the table IDs and the values the table names for all custom tables.

Deleting a Custom Table
-----------------------
You can delete a custom table by calling the ``delete()`` function on the ``ChadoCustomTable`` object. You must know the table ID or the table name to do so.  Here is exmaple code using the table name:

.. code-block:: php

    // Get an instance of the Custom Table service.
    /** @var \Drupal\tripal_chado\Services\ChadoCustomTableManager $ct_service **/
    $ct_service = \Drupal::service('tripal_chado.custom_tables');

    $custom_table = $ct_service->loadbyName('library_stock');
    $custom_table->delete();

Changing a Custom Table
-----------------------
Suppose you have created a custom table for your module and relased the module for others to use.  Later you recognize you need to make changes to the custom table for improved functinoality. To make changes to the table seamlessly for everyone who uses your module, you should create an `update hook function <https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Extension%21module.api.php/function/hook_update_N/10>`_ in your module's ``.install`` file. Within the update hook function you should perform the following:

- Create a new version of the table.
- Copy the data from the old table.
- Delete the old table. 
- Update you module to use the new table.

Then, when your module is upgraded on a Drupal site to the next version, the table changes will happen automatically.





