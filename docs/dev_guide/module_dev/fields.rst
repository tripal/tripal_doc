
Fields (content building blocks)
==================================

Fields are the building blocks of content in Drupal. For example, all content
types (e.g. "Article", or "Basic Page") provide content to the end-user via
fields that are bundled with them.  For example, when adding a basic
page (a default Drupal content type), the end-user is provided with form
elements (or widgets) that allow the user to set the title and the body text
for the page. The "Body" is a field.  When a basic page is
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
  Tripal content type then you will want to create a new field for your
  custom module.

Field Classes
---------------
Anyone who wants to implement a new field in Drupal must implement three
different classes:

- `FieldItemBase <https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Field%21FieldItemBase.php/class/FieldItemBase/9.4.x>`_:
  the class that defines a new field. This class interacts directly with the
  data storage plugin to load and save the data managed by this field.
- `WidgetBase <https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Field%21WidgetBase.php/class/WidgetBase/9.4.x>`_:
  the class that defines the form elements (widgets) provided to the end-user
  to supply or change the data managed by this field.
- `FormatterBase <https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Field%21FormatterBase.php/class/FormatterBase/9.4.x>`_:
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
`SqlContentEntityStorage <https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Entity%21Sql%21SqlContentEntityStorage.php/class/SqlContentEntityStorage/9.4.x>`_
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


Implementing a ChadoFieldItemBase Class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
When creating a new Tripal field, the first class that must be created is the
"type" class. This must extend the `ChadoFieldItemBase` class.

Single-Value Fields
`````````````````````
A single-value field is the simplest Chado field.  This is a field that manages
a data value from a single column in a single Chado table.  For example,
the `genus` column of the `organism` table of Chado stores the genus of an
organism.  For the organism pages provided by Tripal, a single-value
field is used to provide the genus.

Tripal provides some ready-to-use field classes for single-values.  These are:

- **ChadoIntegerTypeDefault**: for integer data.
- **ChadoStringTypeDefault**: for string data with a max length.
- **ChadoTextTypeDefault**: for string data with unlimited length.
- **ChadoRealTypeDefault**:  for real (floating point) numeric data.
- **ChadoBoolTypeDefault**: for boolean data.
- **ChadoDateTimeTypeDefault**:  for data/time data.

.. warning::

  The alpha v2 version of Tripal v4 does not yet implement these fields:
  `ChadoRealTypeDefault`, `ChadoDateTimeTypeDefault`

If you need to add a single-value field for your custom module then you do not
need to write your own field! You can use one of these existing field types.
See the section :ref:`Automate Adding a Field to a Content Type` for
instructions to add the field during installation of your module.

Complex Fields
````````````````
A complex field is one that manages multiple properties (or multiple values) within a single field.  An example
of a complex field is one that stores/loads the organism of a germplasm content type.
Within Chado, a record in the `stock` table is used to store germplasm data. The
`stock` table has a foreign key constraint with the `organism` table. Therefore,
a germplasm page must provide a field that allows the user to specify an organism
for saving. It should also format the organism name for display.

In practice, the `stock` table stores the numeric `organism_id` when saving
a germplasm record.  We could use a single-value `ChadoIntegerTypeDefault` to allow the
user to provide the numeric ID for the organism.  But, this is not practical.
Users should not be required to use a look-up table of numeric organism IDs.

Instead what we need is:

- A field that will store and load a numeric organism ID value that the
  user will never see.
- A field that has access to the genus, species, infraspecific type,
  infraspecific name, etc. of the organism.
- A widget (form element) that allows the user to select an existing organism.
- A formatter that displays the full scientific name of the organism.


Class Setup
`````````````
To create a new field, we will extend the `ChadoFieldItemBase`.  For a new
field named `MyField` we would create a new file in our module here:
`src/Plugin/Field/FieldType/MyfieldType.php`.  The following is an empty
class example:

.. code-block:: php

  <?php

  namespace Drupal\mymodule\Plugin\Field\FieldType;

  use Drupal\tripal_chado\TripalField\ChadoFieldItemBase;
  use Drupal\tripal_chado\TripalStorage\ChadoVarCharStoragePropertyType;
  use Drupal\tripal_chado\TripalStorage\ChadoIntStoragePropertyType;
  use Drupal\tripal_chado\TripalStorage\ChadoTextStoragePropertyType;
  use Drupal\tripal\TripalStorage\StoragePropertyValue;

  /**
   * Plugin implementation of Tripal string field type.
   *
   * @FieldType(
   *   id = "MyField",
   *   label = @Translation("MyField Field"),
   *   description = @Translation("An example field"),
   *   default_widget = "MyFieldWidget",
   *   default_formatter = "MyFieldFormatter"
   * )
   */
  class MyField extends ChadoFieldItemBase {

    public static $id = "MyField";

    /**
     * {@inheritdoc}
     */
    public static function defaultFieldSettings() {
      $settings = [];
      return $settings + parent::defaultFieldSettings();
    }

    /**
     * {@inheritdoc}
     */
    public function fieldSettingsForm(array $form, FormStateInterface $form_state) {
      $elements = [];
      return $elements + parent::fieldSettingsForm($form, $form_state);
    }

    /**
     * {@inheritdoc}
     */
    public static function defaultStorageSettings() {
      $settings = parent::defaultStorageSettings();
      return $settings;
    }

    /**
     * {@inheritdoc}
     */
    public function storageSettingsForm(array &$form, FormStateInterface $form_state, $has_data) {
      $elements = [];
      return $elements + parent::storageSettingsForm($form,$form_state,$has_data);
    }

    /**
     * {@inheritdoc}
     */
    public function getConstraints() {
      $constraints = parent::getConstraints();
      return $constraints;
    }

    /**
     * {@inheritdoc}
     */
    public static function tripalTypes($field_definition) {
      $entity_type_id = $field_definition->getTargetEntityTypeId();

      // Get the settings for this field.
      $settings = $field_definition->getSetting('storage_plugin_settings');
      $base_table = $settings['base_table'];

      // If we don't have a base table then we're not ready to specify the
      // properties for this field.
      if (!$base_table) {
        return;
      }

      // Determine the primary key of the base table.
      $chado = \Drupal::service('tripal_chado.database');
      $schema = $chado->schema();
      $base_schema_def = $schema->getTableDef($base_table, ['format' => 'Drupal']);
      $base_pkey_col = $base_schema_def['primary key'];

      // Return the array of property types.
      return [
        new ChadoIntStoragePropertyType($entity_type_id, self::$id, 'record_id', [
          'action' => 'store_id',
          'drupal_store' => TRUE,
          'path' => $base_table . '.' . $base_pkey_col,
        ]),
      ];
    }
  }

Below is a line-by-line explanation of each section of the code snippet above.

Namespace and Use Statements
``````````````````````````````

The following should always be present and specifies the namespace for this
field.

.. code-block:: php

  namespace Drupal\mymodule\Plugin\Field\FieldType;


.. note::

  Be sure to change `mymodule` in the `namespace` to the name of your module.

.. warning::

  If you misspell the `namespace` your field will not work properly.


The following "use" statements are required for all Chado fields.

.. code-block:: php

  use Drupal\tripal_chado\TripalField\ChadoFieldItemBase;
  use Drupal\tripal\TripalStorage\StoragePropertyValue;

The following "use" statements are for each type of property your class will
support. See the :ref:`Property Types` section for a listing of property
classes you could import if needed.

.. code-block:: php

  use Drupal\tripal_chado\TripalStorage\ChadoVarCharStoragePropertyType;
  use Drupal\tripal_chado\TripalStorage\ChadoIntStoragePropertyType;
  use Drupal\tripal_chado\TripalStorage\ChadoTextStoragePropertyType;


Annotation Section
````````````````````

The annotation section in the class file is the set of in-line comments for the class.
Note the @FieldType stanza in the comments. Drupal
uses these annotations to recognize the new field. It provides information such
as the field ID, label and description. It also indicates the default widget
and formatter class. This annotation is required.

.. code-block:: php

  /**
   * Plugin implementation of Tripal string field type.
   *
   * @FieldType(
   *   id = "MyField",
   *   label = @Translation("MyField Field"),
   *   description = @Translation("An example field"),
   *   default_widget = "MyFieldWidget",
   *   default_formatter = "MyFieldFormatter"
   * )
   */

.. warning::

   If the annotation section is not present, has misspellings, or is not
   complete, the field will not be recognized by Drupal.


Class Definition
``````````````````

Next, the class definition line must extend the `ChadoFieldItemBase` class. You
must name your class the same as the filename in which it is contained (minus
the `.php` extension).

.. code-block:: php

  class MyField extends ChadoFieldItemBase {


.. warning::

    If you misspell the class name such that it is not the same as the filename
    of the file in which it is contained, then the field will not be recognized by
    Drupal.

The defaultFieldSettings() Function
`````````````````````````````````````
This is an optional function.  If your field requires some additional settings
that must be set when the field is added to a content type you can set
those here.

.. code-block:: php

  public static function defaultFieldSettings() {
    $settings = [];
    return $settings + parent::defaultFieldSettings();
  }

This function will return an associative array of all settings your field supports.
You are free to use whatever settings you want.  However, all fields in Tripal
must be mapped to a controlled vocabulary term. Therefore, Tripal will automatically
add the following settings to every field:

  - **termIdSpace**: the namespace of the controlled vocabulary of the term assigned
    to this field (e.g. GO for the Gene Ontology; SO for the Sequence Ontology).
  - **termAccession**: the accession of the term assigned to this field.

These settings are automatically attached to the field when the `parent::defaultFieldSettings()`
function is called.

As an example, the Tripal organism field sets the term ID space and accession:

.. code:: php

  public static function defaultFieldSettings() {
    $settings = parent::defaultFieldSettings();
    $settings['termIdSpace'] = 'OBI';
    $settings['termAccession'] = '0100026';
    return $settings;
  }

Not all fields will need the `termIdSpace` and `termAccession` hardcoded like
in the example above.  A field can be re-used for different terms and those
can be set when the field is added automatically. See the
:ref:`Automate Adding a Field to a Content Type` section.

The defaultStorageSettings() Function
```````````````````````````````````````
The field settings described in the previous function apply to the field. But
some settings may be needed for the storage backend. Drupal distinguishes
between field settings and field storage settings.

.. code:: php

  /**
   * {@inheritdoc}
   */
  public static function defaultStorageSettings() {
    $settings = parent::defaultStorageSettings();
    $settings['storage_plugin_settings']['base_column'] = '';
    return $settings;
  }

In the example above the first line calls ``parent::defaultStorageSettings()``.
this will retrieve the default settings for all Chado fields.  This
includes a setting named ``base_table`` in the ``storage_plugin_settings`` array.
The ``ChadoStorage`` backend always requires a ``base_table`` setting to tell it what table
of Chado this field works with.  Tripal will pass to the storage backend any settings
in the ``storage_plugin_settings`` array. But you are free to add any additional
settings you would like to help manage your field, especially if those settings
help the field define how it will interact with Chado.

An example where a storage setting is needed is in the ``ChadoStringTypeDefault`` field
that gets used for any single-value string mapped to a Chado table column of type ``character varying``.
Here we must set the maximum length of the string. Here is the corresonding ``defaultStorageSettings``
function from this field:

.. code:: php

  public static function defaultStorageSettings() {
    $settings = parent::defaultStorageSettings();
    $settings['max_length'] = 255;
    $settings['storage_plugin_settings']['base_table'] = '';
    $settings['storage_plugin_settings']['base_column'] = '';
    return $settings;
  }

The storageSettingsForm() Function
````````````````````````````````````
If a field needs input from the user to provide values for settings, then the
`storageSettingsForm()` function can be implemented.  Add the form
elements needed for the user to provide values.

For example, the `ChadoStringTypeDefault` field wants to allow the site admin to
set the maximum string length.

.. code:: php

  public function storageSettingsForm(array &$form, FormStateInterface $form_state, $has_data) {
    $elements = [];
    $elements['max_length'] = [
      '#type' => 'number',
      '#title' => t('Maximum length'),
      '#default_value' => $this->getSetting('max_length'),
      '#required' => TRUE,
      '#description' => t('The maximum length of the field in characters.'),
      '#min' => 1,
      '#disabled' => $has_data,
    ];
    return $elements + parent::storageSettingsForm($form,$form_state,$has_data);
  }

The site admin will be able to change the storage settings if they:

- Navigate to `Structure > Tripal Content Types`
- Choose the `Manage fields` option in the dropdown next to the Tripal content type.
- Choose the `Edit` option in the dropdown next to a field of type "Chado String Field Type"
- Clicking on the `Settings` tab.

.. warning::

  The key of the `$elements` array must match the name of the setting.  In the
  example code above, notice that "max_length" is used in the elements
  array and is the name of the setting.

.. note::

  Site admins can change storage settings for a field only before it is used.
  Once the field is used to store data on a live entity, storage settings become
  fixed.

The fieldSettingsForm() Function
``````````````````````````````````
The `fieldSettingsForm()` functions in the same was as the `storageSettingsForm()`
function but for the field settings.


The getConstraints() Function
```````````````````````````````
The `getConstraints()` function is used to provide a set of constraints to
ensure that values provided to fields are appropriate. You can read more
about defining validation contraints for fields
`here <https://www.drupal.org/docs/drupal-apis/entity-api/entity-validation-api/defining-constraints-validations-on-entities-andor-fields>`_.

The following code example is from the `ChadoStringTypeDefault` field. It wants
to ensure that that max length of the string is not exceeded.

.. code:: php

  public function getConstraints() {
    $constraints = parent::getConstraints();
    if ($max_length = $this->getSetting('max_length')) {
      $constraint_manager = \Drupal::typedDataManager()->getValidationConstraintManager();
      $constraints[] = $constraint_manager->create('ComplexData', [
        'value' => [
          'Length' => [
            'max' => $max_length,
            'maxMessage' => t('%name: may not be longer than @max characters.', [
              '%name' => $this
              ->getFieldDefinition()
              ->getLabel(),
              '@max' => $max_length,
            ]),
          ],
        ],
      ]);
    }
    return $constraints;
  }

The tripalTypes() Function
````````````````````````````

The `tripalTypes()` function is used to specify the property types that this
field will manage.  A field may house as many properties as it needs. For
example, the organism field that may appear on a stock page needs to track the
genus, species, infraspecific type, and infraspecific name for an organism.
These can be tracked using properties. Each property is of a
specific type such as string, text, integer, etc. This function is used to define the property types.
A property type is actually an object, thus, this function returns an array of property type
objects. See the :ref:`Property Types` section below for more information about
these object classes.

In the example code block below you can see the steps where the field settings are
retrieved, and then used to create an array containing a single property.
More about properties is described in the next section.

Note that we return from this function early if we do not yet have a base table
defined. This will happen during manual addition of a field through the GUI.
One of the first steps during this process is to select the base table, so
before that is selected, this function should return without doing anything.

.. code-block:: php

  public static function tripalTypes($field_definition) {
    $entity_type_id = $field_definition->getTargetEntityTypeId();

    // Get the settings for this field.
    $settings = $field_definition->getSetting('storage_plugin_settings');
    $base_table = $settings['base_table'];

    // If we don't have a base table then we're not ready to specify the
    // properties for this field.
    if (!$base_table) {
      return;
    }

    // Determine the primary key of the base table.
    $chado = \Drupal::service('tripal_chado.database');
    $schema = $chado->schema();
    $base_schema_def = $schema->getTableDef($base_table, ['format' => 'Drupal']);
    $base_pkey_col = $base_schema_def['primary key'];

    // Return the array of property types.
    return [
      new ChadoIntStoragePropertyType($entity_type_id, self::$id,'record_id', [
        'action' => 'store_id',
        'drupal_store' => TRUE,
        'chado_table' => $base_table,
        'chado_column' => $base_pkey_col
      ]),
    ];
  }


Property Types
````````````````

As was introduced in the :ref:`The tripalTypes() Function` section above, each
field must define the set of properties that it will manage. The set of property
types is returned by the `tripalTypes()` function.

Tripal provides a variety of property type classes that you will use to define these
properties.  These are named after PostgreSQL column types:

- **ChadoBoolStoragePropertyType**: a boolean property.
- **ChadoDateTimeStoragePropertyType**: a date/time property.
- **ChadoIntStoragePropertyType**: an integer property.
- **ChadoRealStoragePropertyType**: a floating point property.
- **ChadoTextStoragePropertyType**: a string property with unlimited length.
- **ChadoVarCharStoragePropertyType**: a string property with a maximum length.

All of these classes can be instantiated with the following arguments:

- The entity type ID:  the unique ID for the entity type.
- The field ID:  the unique ID of the field this property belongs to.
- The property "key": a unique key for this property.
- The property controlled vocabulary term: namespace and accession.
- (For `ChadoVarCharStoragePropertyType` only): The maximum length of the string.
- The property settings: an array of settings for this property. See the :ref:`Property Settings`
  section below for more information on how to specify the property settings array.


Property Settings
```````````````````

The :ref:`Property Types` section above indicated that each property type class
has a fourth argument (fifth argument in the case of `ChadoVarCharStoragePropertyType`)
that provides settings for the property.  These settings
are critical for describing how the property is managed by the ``ChadoStorage``
backend. The settings are an associative array of key-value pairs that specify an
"action" to perform for each property and corresponding helper information.

Several of the actions use a **path** specification, which is a sequence of join
actions to reach the desired column in the desired table. For example if the base
table for the record is ``feature`` and we want to retrieve the organism species,
then the path would be: ``feature.organism_id>organism.organism_id;species``.
Separate multiple joins with a semicolon. For example to get the infraspecific
type name of an organism: ``feature.organism_id>organism.organism_id;organism.type_id>cvterm.cvterm_id;name``.
If we want to specify a column in the base table, then the path might be as simple as: ``feature.feature_id``.

The following actions can be used:

- **store_id**: indicates that the value of this property will hold the
  record ID (or primary key ID) of the record in the base table of Chado. Common
  base tables include: analysis, feature, stock, pub, organism. There will only
  be a single `store_id` action in any given field. This action uses the following
  key/value pairs:

  - **path**: (required) this path specifies the primary key of the base table,
    and is composed of the base table name, a period, and the primary key of
    the base table (e.g., ``feature.feature_id``).
  - **drupal_store**: (required) this setting should always be TRUE for this action.

- **store_link**: indicates that the value of this property will hold the
  value of a foreign key ID to the base table. A property with this action
  is required for fields that provide ancillary information about a record
  but that information is not stored in a column of the base table, but instead
  in a linked table. Examples for such a situation would be
  values from property table: e.g., analysisprop, featureprop, feature_synonym, etc.
  This action uses the following key/value pairs:

  - **path**: (required) this path specifies the primary key of the linked table,
    and specifies a join to the linked table's foreign key, for example
    ``$base_table . '.' . $base_pkey_col . '>' . $linker_table . '.' . $linker_fkey_col``.
  - **drupal_store**: (required) this setting should always be TRUE for this action.
    This forces Tripal to store this value in the Drupal field tables. Without
    this, Tripal cannot link the fields in Drupal with a base record.

- **store_pkey**: indicates that the value of this property will hold the
  primary key ID of a linked table.  As with the ``store_link`` action, a
  property with this action is required for fields that provide ancillary information about a record
  but that information is not stored in a column of the base table, but instead
  in a linked table.  Examples for such a situation would be
  values from property table: e.g., analysisprop, featureprop, feature_synonym, etc.
  This action uses the following key/value pairs:

  - **path**: (required) this path specifies the primary key of the linked table,
    and specifies a join to the linked table's primary key, for example
    ``$base_table . '.' . $base_pkey_col . '>' . $linker_table . '.' . $linker_table_pkey``.
  - **drupal_store**: (required) this setting should always be TRUE for this action.
    This forces Tripal to store this value in the Drupal field tables. Without
    this, Tripal cannot link the fields in Drupal with a base record.

- **store**: indicates that the value of this property should be stored in a
  Chado table. This action uses the following key/value pairs:

  - **path**: (required) this path specifies the table and column that the
    value will be stored in, for example
    ``$linker_table . '.synonym_id'``.
  - **delete_if_empty**: (optional) if TRUE and this field is for ancillary data
    then the ancillary record should be removed if this value is empty.
  - **empty_value**:  (optional) the value that indicates an empty state.  This
    could be ``0``, an empty string, or NULL, whichever is appropriate for the
    property.  This value is used in conjunction with the **delete_if_empty**
    setting.

- **join**: indicates that the value of this property is obtained by joining
  the record ID in the property with the **store_id** action with another table in Chado.

  - **path**: (required) the sequence of joins that should be performed.

    - For example if the base table for the record is `feature` and we want to
      join on the `organism_id` to get the spcies then the path would be:
      `feature.organism_id>organism.organism_id`.
    - Separate multiple joins with a semicolon. For example to get the
      infraspecific name of an organism:
      `feature.organism_id>organism.organism_id;organism.type_id>cvterm.cvterm_id`.

  - **chado_column**: (required) the name of the column from the last join that will
    contain the value for this field.
  - **as**: (optional) to prevent a naming conflict in the SQL that the
    `ChadoStorage` backend will generate, you can rename the `chado_column`
    with a different name.

- **read_value**: this is almost the same as join, but there will be no modification
  to the value if we edit a content type, only look up an existing value.

- **replace**: indicates that the value of this property is a tokenized string
  and should be replaced with values from other properties.

  - **template**: (required) a string containing the value of the field. The
    string should contain tokens that will be replaced by values of other properties.  Tokens are
    surrounded by square brackets and contain the keys of other properties. For example,
    in the `ChadoOrganismTypeDefault` field, a property is created that builds
    the full scientific name of an organism with the following template string:
    "[organism_genus] [organism_species] [organism_infraspecific_type] [organism_infraspecific_name]".

- **function**: indicates that the value of this property will be set by a
  callback function. You will need to pass the namespace for the
  callback function, and the function name. Chado storage will generate a
  context array that the function can access to calculate its value.
  The callback function then returns a single value which becomes the value
  for this property.

  - **namespace**: (required) the namespace of the callback function, which may be the
    namespace of the field itself, or the namespace of a parent class.
  - **function**: (required) the name of the callback function

.. note::

  All of the core tripal fields that link to another content type define a `function` property to
  retrieve the Drupal entity corresponding to that linked content. We also pass through the
  foreign key which is needed to look up the Chado entity.
  For an example, see any of the linking fields such as the `ChadoContactTypeDefault` field.


As an example, let's look at the ``tripalTypes()`` function of the field that
allows an end-user to add an organism to content.  This is a simplified version of the 
code that is found in the
``tripal_chado\src\Plugin\Field\FieldType\ChadoOrganismTypeDefault.php``
file of Tripal.

.. warning::

  This is just an example, the full version of this field is significantly more complicated.
  In the full version we store all of the organism table columns, and in addition to
  supporting base tables with an `organism_id` column, we also handle organisms connected
  through a linking table such as `organism_pub` or `featuremap_organism`.

.. code:: php

  public static function tripalTypes($field_definition) {
    $entity_type_id = $field_definition->getTargetEntityTypeId();

    // Get the settings for this field.
    $settings = $field_definition->getSetting('storage_plugin_settings');
    $base_table = $settings['base_table'];

    // If we don't have a base table then we're not ready to specify the
    // properties for this field.
    if (!$base_table) {
      return;
    }

    // Get the length of the database fields so we don't go over the size limit.
    $chado = \Drupal::service('tripal_chado.database');
    $schema = $chado->schema();
    $organism_def = $schema->getTableDef('organism', ['format' => 'Drupal']);
    $cvterm_def = $schema->getTableDef('cvterm', ['format' => 'Drupal']);
    $genus_len = $organism_def['fields']['genus']['size'];
    $species_len = $organism_def['fields']['species']['size'];
    $iftype_len = $cvterm_def['fields']['name']['size'];
    $ifname_len = $organism_def['fields']['infraspecific_name']['size'];
    $scientific_name_len = $genus_len + $species_len + $iftype_len + $ifname_len + 3;

    // Get the base table columns needed for this field.
    $base_schema_def = $schema->getTableDef($base_table, ['format' => 'Drupal']);
    $base_pkey_col = $base_schema_def['primary key'];
    $base_fk_col = array_keys($base_schema_def['foreign keys']['organism']['columns'])[0];

    // Get the CV terms used for each of the properties
    $storage = \Drupal::entityTypeManager()->getStorage('chado_term_mapping');
    $mapping = $storage->load('core_mapping');
    $record_id_term = 'SIO:000729';
    $drupal_entity_term = 'schema:ItemPage';
    $organism_id_term = $mapping->getColumnTermId($base_table, 'organism_id');
    $genus_term = $mapping->getColumnTermId('organism', 'genus');
    $species_term = $mapping->getColumnTermId('organism', 'genus');
    $infraspecific_type_term = $mapping->getColumnTermId('cvterm', 'name');
    $infraspecific_name_term = $mapping->getColumnTermId('organism', 'infraspecific_name');
    $scientific_name_term = 'NCBITaxon:scientific_name';

    // Return the properties for this field.
    return [
      new ChadoIntStoragePropertyType($entity_type_id, self::$id, 'record_id', $record_id_term, [
        'action' => 'store_id',
        'drupal_store' => TRUE,
        'path' => $base_table . '.' . $base_pkey_col,
      ]),
      new ChadoIntStoragePropertyType($entity_type_id, self::$id, 'entity_id', $drupal_entity_term, [
        'action' => 'function',
        'drupal_store' => TRUE,
        'namespace' => self::$chadostorage_namespace,  // the namespace of the parent class Drupal\tripal_chado\Plugin\TripalStorage\ChadoStorage
        'function' => self::$drupal_entity_callback,  // i.e. drupalEntityIdLookupCallback
        'fkey' => 'organism_id',
      ]),
      new ChadoIntStoragePropertyType($entity_type_id, self::$id, 'organism_id', $organism_id_term, [
        'action' => 'store',
        'drupal_store' => TRUE,
        'path' => $base_table . '.' . $base_fk_col,
      ]),
      new ChadoVarCharStoragePropertyType($entity_type_id, self::$id, 'organism_genus', $genus_term, $genus_len, [
        'action' => 'read_value',
        'drupal_store' => FALSE,
        'path' => $base_table . '.organism_id>organism.organism_id;genus',
      ]),
      new ChadoVarCharStoragePropertyType($entity_type_id, self::$id, 'organism_species', $species_term, $species_len, [
        'action' => 'read_value',
        'drupal_store' => FALSE,
        'path' => $base_table . '.organism_id>organism.organism_id;species',
      ]),
      new ChadoVarCharStoragePropertyType($entity_type_id, self::$id, 'organism_infraspecific_type', $infraspecific_type_term, [
        'action' => 'read_value',
        'drupal_store' => FALSE,
        'path' => $base_table . '.organism_id>organism.organism_id;organism.type_id>cvterm.cvterm_id;name',
        'as' => 'infraspecific_type'
      ]),
      new ChadoVarCharStoragePropertyType($entity_type_id, self::$id, 'organism_infraspecific_name', $infraspecific_name_term, $ifname_len, [
        'action' => 'read_value',
        'drupal_store' => FALSE,
        'path' => $base_table . '.organism_id>organism.organism_id;infraspecific_name',
      ]),
      new ChadoVarCharStoragePropertyType($entity_type_id, self::$id, 'organism_scientific_name', $scientific_name_term, $scientific_name_len, [
        'action' => 'replace',
        'drupal_store' => FALSE,
        'template' => "[organism_genus] [organism_species] [organism_infraspecific_type] [organism_infraspecific_name]",
      ])
    ];
  }

The Tripal organism property is used to associate an organism
to a base record that has an ``organism_id`` column in the Chado table.  We only
need to store the ``organism_id`` to make this work, but again, requiring an
end-user to enter a numeric organism is not ideal. Also we want our formatter
to print a nicely formatted scientific name for the organism.  We need more
properties.

In the code above, we create eight properties for this field.  As required, we
must have a property that uses the action ``store_id`` that will house the
record ID (e.g., feature.feature_id).  Because this field is supposed to
store the ``organism_id`` for the feature, stock, etc., we have a property that
uses the action ``store`` and maps to the ``organism_id`` column of the table.

Because when the field displays the organism on a page, we would like to be able
to click on the organism name, and go to the corresponding organism page, we need
to store the Drupal entity ID for that organism. This is handled by the `entity_id`
property. The field formatter can use this value to create a URI to the organism
page.

We also have a variety of properties with a `read_value` action.  These are used to
join on the base table to get information such as the genus, species,
and infraspecific type, but these are read-only, the values stored in Chado will
not be modified by this field.  Lastly, we have a property with the action ``replace``
that uses a tokenized string to create the full scientific name for the organism.


Implementing a TripalWidgetBase Class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. warning::

  This documentation is still being developed. In the meantime there are examples
  in the Tripal core codebase. Specifically, look in the
  `tripal_chado/src/Plugin/Field/FieldWidget` directory.

Implementing a TripalFormatterBase Class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. warning::

  This documentation is still being developed. In the meantime there are examples
  in the Tripal core codebase. Specifically, look in the
  `tripal_chado/src/Plugin/Field/FieldFormatter` directory.

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
