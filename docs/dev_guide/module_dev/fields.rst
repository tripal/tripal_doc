
Fields
======

Fields are the building blocks of content in Drupal. For example, all content
types (e.g. "Article", or "Basic Page") provide content to the end-user via
fields that are bundled with content types.  For example, when adding a basic
page (a default Drupal content type), the end-user is provided with form
elements (or widgets) that allow the user to set the title and the body text
for the page. The "Body" is a field.  When a basic page is
viewed, the body is rendered on the page using formatters and
Drupal stores the values for the body in the database. Every
field, therefore, provides three types of functionality: instructions
for storage, widgets for allowing input, and formatters for rendering.

Drupal provides a variety of built-in fields, and extension module developers
have created a multitude of new fields that can be added by the site admin
to add new functionality and support new types of data.  Tripal follows this
model, but adds a variety of new object oriented classes to support storage
of data in biological databases such as Chado.

.. note::

  Note every custom module will require fields. But if you have a new way
  to store and retrieved data or if you need data to appear on an existing
  Tripal content type then you will want to create a new field.

Field Classes
-------------
Anyone who wants to implement a new field in Drupal must implement three
different classes:

- `FieldItemBase <https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Field%21FieldItemBase.php/class/FieldItemBase/9.4.x>`_:
  the class that defines a new field.
- `WidgetBase <https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Field%21WidgetBase.php/class/WidgetBase/9.4.x>`_:
  the class that defines the form elements (widgets) provided to the end-user
  to provide data for the field.
- `FormatterBase <https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Field%21FormatterBase.php/class/FormatterBase/9.4.x>`_:
  the class taht defines how the field is rendered on the page.

However, these classes were extended by Tripal to provide additional
functionality that allows Tripal-based fields to communicate with the data
store where biological data is house. Chado is the default data store provided
by Tripal.  Custom module develoeprs who wish to add new fields to Tripal
that should be housed in a Chado database should implement the following
three classes for every new field:

- **ChadoFieldItemBase**: a class that extends the Drupal class `FieldItemBase`.
  It is used for data housed in Chado.
- **TripalWidgetBase**: a class that extends the Drupal class `WidgetBase`.
- **TripalFormatterBase**: a class that extends the Drupal class `FormatterBase`.


How to Write a New Field for Chado
-----------------------------------

Directory Setup
^^^^^^^^^^^^^^^
Drupal manages fields using its `Plugin API <https://www.drupal.org/docs/drupal-apis/plugin-api>`_.
this means that as long as new field classes are placed in the correct directory
and have the correct "annotations" in the class comments then Drupal will find it
and make it available.  All new fields must be placed inside of the custom
extension module inside of the `src/Plugin/Field` directory. There are three
subdirectories, one each for the three elements of a field:
`FieldType`, `FieldWidget`, `FieldFormatter`.  For a new field named `Myfield`
the directory structure would like like the following:


.. code::

  mymodule
  ├── config
  ├── src
  │   └── Plugin
  │       └── Field
  │           ├── FieldFormatter
  |           |   └── MyfieldFormatter.php
  │           ├── FieldType
  |           |   └── MyfieldType.php
  │           └── FieldWidget
  |               └── MyfieldWidget.php
  |
  ├── tests
  └── templates


About the Storage Backend
^^^^^^^^^^^^^^^^^^^^^^^^^
Default Behavior
````````````````
By default, all built-in fields provided by Drupal store their data in the
Drupal database schema.  Drupal will create a database table for every field.
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

Support for Chado Storage
`````````````````````````
For fields storing data in Chado, Tripal provides some additional support
that extends the default behavior just described in the previous section.


Implementing a ChadoFieldItemBase Class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Storing

Single Valued Fields
~~~~~~~~~~~~~~~~~~~~
A single valued field is one where

Implementing a TripalWidgetBase Class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Implementing a TripalFormatterBase Class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Automate Adding a Field to a Content Type
-----------------------------------------

What About Fields not for Chado?
--------------------------------
