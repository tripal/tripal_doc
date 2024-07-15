
Fields Overview
================

Fields are the building blocks of content in Drupal. For example, all content
types (e.g. "Article", or "Basic Page") provide content to the end-user via
fields that are bundled with the content type. For example, when adding a basic
page (a default Drupal content type), the end-user is provided with form
elements (or widgets) that allow the user to set the title and the body text
for the page. The "Body" is a field. When a basic page is
viewed, the body is rendered on the page using formatters, and
Drupal stores the values for the body in the database. Every
field, therefore, provides three types of functionality: instructions
for storage, widgets for allowing input, and formatters for rendering.

Drupal provides a variety of built-in fields, and extension module developers
have created a multitude of new fields that can be added by the site admin
to add new functionality and support new types of data.  Tripal follows this
model, but adds a variety of new object oriented classes to support storage
of data in biological databases such as Chado.

.. note::

  Not every custom module will require fields. But if you need a new way
  to store and retrieve data, or if you need data to appear on an existing
  Tripal content type, then you will want to create a new field for your
  custom module.

Field Classes
---------------
Anyone who wants to implement a new field in Drupal must implement three
different classes:

- `FieldItemBase <https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Field%21FieldItemBase.php/class/FieldItemBase/>`_:
  the class that defines a new field. This class interacts directly with the
  data storage plugin to load and save the data managed by this field.
- `WidgetBase <https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Field%21WidgetBase.php/class/WidgetBase/>`_:
  the class that defines the form elements (widgets) provided to the end-user
  to supply or change the data managed by this field.
- `FormatterBase <https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Field%21FormatterBase.php/class/FormatterBase/>`_:
  the class that defines how the field is rendered on the page.

These classes were extended by Tripal to provide additional
functionality that allows Tripal-based fields to communicate with additional
data stores housing biological data. There is support for a number of
types of datastores (e.g. MySQL, PostgreSQL, SQLite) in core Drupal but you are
required to choose a single data store for your site. The extension to support
multiple data stores provided by Tripal allows you to keep your biological data
separate from the website and still available to scientific analysis and
visualization tools.

Chado is the default data store implemented within Tripal as it offers flexible
support for a wide breadth of biological data types, ontology-focused metadata,
and robust data integrity. The following documentation will demonstrate how to
develop custom fields with data stored in Chado. However, the Tripal data storage
plugin and Tripal Fields are designed to work with additional data stores and
documentation showing how to take advantage of this will be written in the future.

Custom module developers who wish to add new fields to Tripal whose data are
stored in Chado should implement the following three classes for every new field:

- **ChadoFieldItemBase**: extends the Tripal class `TripalFieldItemBase`
  which extends the Drupal class `FieldItemBase`. The `TripalFieldItemBase`
  must be used for all fields attached to Tripal content types, and the
  `ChadoFieldItemBase` adds Chado-specific support.
- **ChadoWidgetBase**: extends the Tripal class `TripalWidgetBase`
  which extends the Drupal class `WidgetBase`.
- **ChadoFormatterBase**: extends the Tripal class `TripalFormatterBase`
  which extends the Drupal class `FormatterBase`.


How to Write a New Field for Chado
------------------------------------

Directory Setup
^^^^^^^^^^^^^^^^
Drupal manages fields using its `Plugin API <https://www.drupal.org/docs/drupal-apis/plugin-api>`_.
This means that as long as new field classes are placed in the correct directory
and have the correct "annotations" in the class comments, then Drupal will find them
and make the field available.  All new fields must be placed in the custom
extension module inside of the `src/Plugin/Field` directory. There are three
subdirectories, one each for the three elements of a field:
`FieldType`, `FieldWidget`, `FieldFormatter`.  For a new field named `MyField`
the directory structure would look like the following:


.. code::

  mymodule
  ├── config
  ├── src
  │   └── Plugin
  │       └── Field
  │           ├── FieldFormatter
  |           |   └── MyFieldFormatter.php
  │           ├── FieldType
  |           |   └── MyFieldType.php
  │           └── FieldWidget
  |               └── MyFieldWidget.php
  |
  ├── tests
  └── templates

Note that the file name must match the class name.

Naming convention
^^^^^^^^^^^^^^^^^

The filename for your new field should adhere to the following schema. Please
note the casing used. In addition, for fields that will be included in Tripal
Core, note the 'Default' designation, any fields added by extension modules
should **not** use 'Default':

  .. table:: Tripal Core modules:

    +------------------+-----------------------------+
    | File             | Filename                    |
    +==================+=============================+
    | Type             | MyFieldTypeDefault.php      |
    +------------------+-----------------------------+
    | Formatter        | MyFieldFormatterDefault.php |
    +------------------+-----------------------------+
    | Widget           | MyFieldWidgetDefault.php    |
    +------------------+-----------------------------+

  .. table:: Extension modules:

    +------------------+-----------------------------+
    | File             | Filename                    |
    +==================+=============================+
    | Type             | MyFieldType.php             |
    +------------------+-----------------------------+
    | Formatter        | MyFieldFormatter.php        |
    +------------------+-----------------------------+
    | Widget           | MyFieldWidget.php           |
    +------------------+-----------------------------+ 

Within the individual files, in the annotation section, the ID also has to follow 
a specific format, and would look like the following:

  .. table:: Tripal Core modules:

    +------------------+----------------------------+
    | File             | ID within annotation       |
    +==================+============================+
    | Type             | my_field_type_default      |
    +------------------+----------------------------+
    | Formatter        | my_field_formatter_default |
    +------------------+----------------------------+
    | Widget           | my_field_widget_default    |
    +------------------+----------------------------+ 

  .. table:: Extension modules:

    +------------------+----------------------------+
    | File             | ID within annotation       |
    +==================+============================+
    | Type             | my_field_type              |
    +------------------+----------------------------+
    | Formatter        | my_field_formatter         |
    +------------------+----------------------------+
    | Widget           | my_field_widget            |
    +------------------+----------------------------+ 

About the Storage Backend
^^^^^^^^^^^^^^^^^^^^^^^^^^

Default Drupal Behavior
````````````````````````
By default, all built-in fields provided by Drupal store their data in the
Drupal database.  This is provided by Drupal's
`SqlContentEntityStorage <https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Entity%21Sql%21SqlContentEntityStorage.php/class/SqlContentEntityStorage/>`_
storage plugin. This storage plugin will create a database table for every field.
For example, if you explore the Drupal database tables you will see the
following for the body field attached to the node content type:

.. code::

                                Table "public.node__body"
      Column    |          Type          | Collation | Nullable |        Default
  --------------+------------------------+-----------+----------+-----------------------
   bundle       | character varying(128) |           | not null | ''::character varying
   deleted      | smallint               |           | not null | 0
   entity_id    | bigint                 |           | not null |
   revision_id  | bigint                 |           | not null |
   langcode     | character varying(32)  |           | not null | ''::character varying
   delta        | bigint                 |           | not null |
   body_value   | text                   |           | not null |
   body_summary | text                   |           |          |
   body_format  | character varying(255) |           |          |
  Indexes:
      "node__body____pkey" PRIMARY KEY, btree (entity_id, deleted, delta, langcode)
      "node__body__body_format__idx" btree (body_format)
      "node__body__bundle__idx" btree (bundle)
      "node__body__revision_id__idx" btree (revision_id)
  Check constraints:
      "node__body_delta_check" CHECK (delta >= 0)
      "node__body_entity_id_check" CHECK (entity_id >= 0)
      "node__body_revision_id_check" CHECK (revision_id >= 0)

The values provided by the user for the body of a node type are housed in this
table.  The following describes the columns of the table.

These columns are present for all fields

- `bundle`: the machine name of the content type (e.g. node)
- `deleted`: a value of 1 indicates the field is marked for deletion
- `entity_id`: the unique ID of the node that this field belongs to.
- `revision_id`: the node revision ID.
- `langcode`: for fields that are translatable, this indicates the language
  of the saved value.
- `delta`: for fields that support multiple values, this is the index (starting
  at zero) for the order of the values.

These columns are specific to the field:

- `body_value`:  stores the value for the body
- `body_summary`: stores the body summary
- `body_format`: instructions for how the body should be rendered (e.g. plain
  text, HTML, etc.)


Support for Chado
```````````````````
For fields storing biological data in something other than Drupal tables,
Tripal provides its own plugin named `TripalStorage`.  If a custom module wants to
store data in a data backend other than in Drupal tables, it must create an implementation
of this plugin. By default, Tripal provides the `ChadoStorage` implementation
that allows a field to interact with a Chado database.

The `ChadoStorage` backend extends the `SqlContentEntityStorage` and
will create a table in the Drupal schema for every Tripal field that is
added to a content type.  The table columns will include the same default
columns as a Drupal field, and will also include a set of additional columns
for every property the field wants to manage.

The `ChadoStorage` backend is different from `SqlContentEntityStorage`
in that it will not store the values of the properties in the table.  This is
because those values need to be stored in Chado--we do not want to duplicate
the data in the Drupal schema and the Chado schema.  The `ChadoStorage`
backend is also different in that it requires a set of property settings that
help it control how properties of a field are stored, edited and loaded from
Chado. Instructions for working with properties and storing data in Chado are
described in the following sections.

.. note::

  The `ChadoStorage` backend will not store biological data in the Drupal
  tables--only in the Chado tables.  The only exceptions are record IDs that
  associate the field with data in Chado.


See the next section :ref:`Field Types` to learn how to define the
properties for a new field.

Automate Adding a Field to a Content Type
------------------------------------------

.. warning::

  This documentation is still being developed. In the meantime there are
  examples for programmatically adding TripalFields in the Tripal core codebase.
  Specifically, look in the Chado Preparer class in
  `tripal_chado/src/Task/ChadoPreparer.php`.

What About Fields not for Chado?
---------------------------------

.. warning::

  This documentation is still being developed. Currently ChadoStorage provides
  an example for implementing the TripalStorage data store extension. It can be
  found in `tripal_chado/src/Plugin/TripalStorage/ChadoStorage.php`.
