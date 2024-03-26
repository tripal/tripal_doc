Custom Tables in Chado
======================
The Chado database provides a variety of tables for storing biological and ancillary data, however there may be situations where you need to make customizations to Chado to hold new types of data or to link existing data.  Rather than make Changes to existing Chado tables, it is recommended to develop custom tables. Modules can provide such tables during installation and provide the necessary tools to interact with the data in the custom table (e.g., new data loaders, content types, materialized views, and/or fields). This section describes how to programmatically create and manage Custom tables in Chado.

.. warning::
    You should avoid making any changes to existing Chado tables as it could make upgrades to future releases of Chado more difficult and could break functionality in Tripal that expects Chado tabes to be a certain way.  Instead, use custom tables!

To support custom tables in Chado, Tripal provides a service that has management functions for working with custom tables in general, and provides the `ChadoCustomTable` object which has support for working with individual tables.  Each table can be identified using its name and a unique ID that is automatically assigned to the Table. 


.. note::
    For a hands-on example to programmatically create and manage custom tables see :doc:`../lessons/custom_tables`.