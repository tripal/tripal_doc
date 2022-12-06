
Fields
======

Fields are the building blocks of content in Drupal. For example, all content
types (e.g. "Article", or "Basic Page") provide content to the end-user via
fields that are bundled with them.  For example, when adding a basic
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

  Note every custom module will require fields. But if you need a new way
  to store and retrieved data, or if you need data to appear on an existing
  Tripal content type then you will want to create a new field for your
  custom module.

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

These classes were extended by Tripal to provide additional
functionality that allows Tripal-based fields to communicate with the data
store where biological data is house. Chado is the default data store supported
by Tripal.  Custom module developers who wish to add new fields to Tripal
should implement the following three classes for every new field:

- **ChadoFieldItemBase**: a class that extends the Tripal class `TripalFieldItemBase`
  which extends the Drupal class `FiedlItemBase`. The `TripalFieldItemBase`
  must be used for all fields attached to Tripal content types and the
  `ChadoFieldItemBase` adds Chado-specific support.
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


About the Storage Backend
^^^^^^^^^^^^^^^^^^^^^^^^^
Default Behavior
~~~~~~~~~~~~~~~~
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
`````````````````
For fields storing biological data in stores other than Drupal tables,
Tripal provides its own plugin named `TripalStorage`.  If a custom module wants to
store data in a data backend other than in Drupal tables, it must create an implementation
of this plugin. By default, Tripal provides the `ChadoStorage` implementation
that allows a field to interact with a Chado database.

The `ChadoStorage` backend is similar to the `SqlContentEntityStorage` in
that it will create a table in the Drupal schema for every Tripal field that is
added to a content type.  The table columns will have the same default columns.
It will also have a set of additional columns for every property the field wants
to manage.

The `ChadoStorage` backend is different from the `SqlContentEntityStorage`
in that it will not store the values of the properties in the table.  This is
because those values need to be stored in Chado--we do not want to duplicate
the data in the Drupal schema and the Chado schema.  The  `ChadoStorage`
backend is also different in that it requires a set of property settings that
help it control how properties of a field are stored, edited and loaded from
Chado. Instructions for working with properties and storing data in Chado are
described in the following sections.

.. note::

  The `ChadoStorage` backend will not store biological data in the Drupal
  tables--only in the Chado tables.  The only exception is record IDs that
  associate the field with the entity.


Implementing a ChadoFieldItemBase Class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
When creating a new Tripal field, the first class that must be created is the
"type" class. This must extend the `ChadoFieldItemBase` class.

Single-Value Fields
~~~~~~~~~~~~~~~~~~~
A single-value field is the simplest Chado field.  This is a field that manages
a data value from a single column in a single Chado table.  For example,
the `genus` column of the `organism` table of Chado stores the genus of an
organism.  For the organism pages provided by Tripal, a single-value
field is used to provide the genus.

Tripal provides some ready-to-use field classes for single-values.  These are:

- **ChadoIntegerTypeItem**: for integer data.
- **ChadoStringTypeItem**: for string data with a max length.
- **ChadoTextTypeItem**: for string data with unlimited length.
- **ChadoRealTypeItem**:  for real (floating point) numberic data.
- **ChadoBoolTypeItem**: for boolean data.
- **ChadoDateTimeTypeItem**:  for data/time data.

.. warning::

  The alpha v1 version of Tripal v4 does not yet implement these fields:
  `ChadoRealTypeItem`,  `ChadoBoolTypeItem`, `ChadoDateTimeTypeItem`

If you need to add a single-value field for your custom module then you do not
need to write your own field! You can use one of these existing field types.
See the section :ref:`Automate Adding a Field to a Content Type` for
instructions to add the field during installation of your module.

Complex Fields
~~~~~~~~~~~~~~
A complex field is one that manages multiple properties within a single field.  An example
of a complex field is one that stores/loads the organism of a germplasm content type.
Within Chado, a record in the `stock` table is used to store germplasm data. The
`stock` table has a foreign key constraint with the `organism` table. Therefore,
a germplasm page must provide a field that allows the user to specify an organism
for saving and format the organism name for display.

In practice, the `stock` table stores the numeric `organism_id` when saving
a germplasm.  We could use a single-value `ChadoIntegerTypeItem` to allow the
user to provide the numeric ID for the organism.  But, this is not practical.
Users should not be required to use a look-up table of numeric organism IDs.

Instead what we need is:

- A field that will store and load a numeric organism ID value that the
  user will never see.
- A field that has access to the genus, species, infraspecific type,
  infraspecific name, etc., of the organism.
- A widget (form element) that allows the user to select an existing organism.
- A formatter that prints the full scientific name of the organism.


Class Setup
~~~~~~~~~~~
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
      $settings = [];
      return $settings + parent::defaultStorageSettings();
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
      $types = [];

      $default_types = ChadoFieldItemBase::defaultTripalTypes($entity_type_id, self::$id);
      $types = array_merge($types, $default_types);
      return $types;
    }

    /**
     * {@inheritdoc}
     */
    public function tripalValuesTemplate($field_definition) {
      $values = [];

      $default_values = ChadoFieldItemBase::defaultTripalValuesTemplate($entity_type_id, self::$id, $entity_id);
      $values = array_merge($values, $default_values);
      return $values;
    }
  }

Below is a line-by-line explanation of each section of the code snippet above.

Namespace and Use Statements
````````````````````````````

The following should always be present and specifies the namespace for this
field.

.. code-block:: php

  namespace Drupal\mymodule\Plugin\Field\FieldType;


.. note::

  Be sure to change `mymodule` in the namespace to the name of your module.

.. warning::

  If you misspell the namespace your field will not work properly.


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
``````````````````

The following section in the class file is the in-line comments for the class.
Note the @FieldType stanza in the comments. These are annotations.  Drupal
uses these annotations to recognize our field. it provides information such
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

   If the annotation section is not present, has misspellings or is not
   complete, the field will not be recognized by Drupal.


Class Definition
````````````````

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
```````````````````````````````````
This is an optional function.  If your field requires some additional settings
in the form of key/value pairs, that must be set when the field is added to
a content type you can set those here.  An example of where default
settings are added will be shown later.

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

.. note::

   Not all fields will need the `termIdSpace` and `termAccession` hardcoded like
   in the example above.  A field can be re-used for different terms and those
   can be set with the field is added automatically. See the
   :ref:`Automate Adding a Field to a Content Type` section.

The defaultStorageSettings() Function
`````````````````````````````````````
The field settings described in the previous function apply to the field. But
some settings may be needed for the storage backend. Drupal distinguishes
between field settings and field storage settings.  If you need to provide any
settings for the field as a whole you can add any that you need.

For example, the `ChadoStringTypeItem` field needs to keep track of the maximum
size of the string. This is set in the `defaultStorageSettings` function.

.. code:: php

  public static function defaultStorageSettings() {
    $settings = [
      'max_length' => 255,
    ];
    return $settings + parent::defaultStorageSettings();
  }

The storageSettingsForm() Function
``````````````````````````````````
If a field needs input from the user to provide values for settings, then the
`storageSettingsForm()` function can be implemented.  Simply add the form
elements needed for the user to provide values.

For example, the `ChadoStringTypeItem` field wants to allow the site admin to
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
  Once the field is used to store data on a live entity, storage settings are
  fixed.

The fieldSettingsForm() Function
````````````````````````````````
The `fieldSettingsForm()` functions in the same was as the `storageSettingsForm()`
function but for the field settings instead.


The getConstraints() Function
`````````````````````````````
The `getConstraints()` function is used to provide a set of constraints to
ensure that values provided to fields are appropriate. You can read more
about defining validation contraints for fields
`here <https://www.drupal.org/docs/drupal-apis/entity-api/entity-validation-api/defining-constraints-validations-on-entities-andor-fields>`_.

For following code example, is from the `ChadoStringTypeItem` field. It wants
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
``````````````````````````

The `tripalTypes()` function is used to specify the property types that this
field will manage.  A field may house as many properties as it needs. For
example, the organism field needs to know the genus, species, infraspecific type,
and infraspecific name for an organism. These are each properties and house
a single value. Each property has a specific type (e.g., string, text, integer, etc.)
and those types must be defined. This function is used to define the property types.
A property type is an object.  Thus, this function returns an array of property type
objects. See the :ref:`Property Types` section below for more information about
these object classes.

Note, that this function must call the `ChadoFieldItemBase::defaultTripalTypes()`
function and merge the property type objects returned with those defined in
this function.

.. code-block:: php

    public static function tripalTypes($field_definition) {
      $types = [];

      $default_types = ChadoFieldItemBase::defaultTripalTypes($entity_type_id, self::$id);
      $types = array_merge($types, $default_types);
      return $types;
    }


.. warning::

    If you do not call `ChadoFieldItemBase::defaultTripalTypes()` and merge its
    returned property types with those you define, then your field may not work
    properly with the `ChadoStorage` backend.


The tripalValuesTemplate() Function
```````````````````````````````````
The `tripalValuesTemplate()` function provides a set of empty property value
objects.  The storage backend will call this function to get the set of
property objects and then set their values.  See the :ref:`Property Values`
section below for more information about these object classes.

Note, that this function must call the `ChadoFieldItemBase::defaultTripalTypes()`
function and merge the property value objects returned with those defined in
this function.

.. code-block:: php

    public function tripalValuesTemplate($field_definition) {
      $values = [];

      $default_values = ChadoFieldItemBase::defaultTripalValuesTemplate($entity_type_id, self::$id, $entity_id);
      $values = array_merge($values, $default_values);
      return $values;
    }

.. warning::

    If you do not call `ChadoFieldItemBase::defaultTripalValuesTemplate()` and merge its
    returned property values with those you define, then your field may not work
    properly with the `ChadoStorage` backend.


Property Types
``````````````
As was introduced in the :ref:`The tripalTypes() Function` section above, each
field must define the set of properties that it will manage. The set of property
types is returned by the `tripalTypes()` function.

Tripal provides a variety of property type classes that you will use to define these
properties.  These are named after PostgreSQL column types:

- **ChadoBoolStoragePropertyType**: a boolean property.
- **ChadoDateTimeStoragePropertyType**: a date/time property.
- **ChadoIntStoragePropertyType**: an integer property.
- **ChadoRealStoragePropertyType**: a floating point property.
- **ChadoTextStoragePropertyType**: an unlimited string property.
- **ChadoVarCharStoragePropertyType**: a string property with a maximum length.

All of these classes can be instantiated with four arguments:

- The entity type ID:  the unique ID for the entity type.
- The field ID:  the unique ID of the field this property belongs to.
- The property "key": a unique key for this property.
- The property settings: an array of settings for this property.

As an example, the following creates a new property of type "integer" with the
key of "value".

.. code:: php

  public function tripalTypes($field_definition) {
    $values = [];

    // Get the entity type and default property settings.
    $entity_type_id = $field_definition->getTargetEntityTypeId();
    $settings = $field_definition->getSetting('storage_plugin_settings');

    // Get the default property settings provided when the field was created.
    $value_settings = $settings['property_settings']['value'];

    // Create a new value property of type integer.
    $values[] = new ChadoIntStoragePropertyType($entity_type_id, self::$id, 'value', $value_settings);

    // Get the default Tripal property types and add those to our list.
    // This will add in the property with key `record_id`.
    $default_values = ChadoFieldItemBase::defaultTripalValuesTemplate($entity_type_id, self::$id, $entity_id);
    $values = array_merge($values, $default_values);

    // Return the final list of property type values.
    return $values;
  }

See the :ref:`Property Settings` section below for more information on how to
specify the property settings array.

Every field will have a `record_id` property.  This is added by the call to then
`parent::defaultTripalTypes()` function. This field keeps track of the record
ID (or primary key) of the record in Chado that this field is associated with.

Every field must also include at a minimum a single property with a key of `value`.


.. note::

  All fields must have two properties with the keys: `record_id` and `value`.
  The `record_id` property is automatically provided. The developer must
  create the `value` property.

Property Values
```````````````
As was introduced in the :ref:`The tripalValuesTemplate() Function` section above, each
field must provide an array of empty property value objects. The set of property
value objects is returned by the `tripalValuesTemplate()` function. Tripal
provides a single class for this. The `StoragePropertyValue` class.

This class can be instantiated with four arguments:

- The entity type ID:  the unique ID for the entity type.
- The field ID:  the unique ID of the field this property belongs to.
- The property "key": a unique key for this property.
- The entity id: a unique ID for the entity.

For example:

.. code:: php

  public function tripalValuesTemplate($field_definition) {

    // Get information about the entity that this field is attached to.
    $entity = $this->getEntity();
    $entity_type_id = $entity->getEntityTypeId();
    $entity_id = $entity->id();

    // Build the values array.
    $values[] = new StoragePropertyValue($entity_type_id, self::$id, 'value', $entity_id),

    // Get the default Tripal property values and add those to our list.
    // This will add in the property with key `record_id`.
    $default_values = ChadoFieldItemBase::defaultTripalValuesTemplate($entity_type_id, self::$id, $entity_id);
    $values = array_merge($values, $default_values);

    // Return the final list of property type values.
    return $values;
  }

.. note::

  You must create an instance of `StoragePropertyValue` class for every property
  that was defined in the `tripalTypes()` function.


Property Settings
`````````````````
The :ref:`Property Types` section above indicated that each property type class
has a fourth argument that provides settings for the property.  These settings
are critical for describing how the property is managed by the `ChadoStorage`
backend. The settings are an associative array of key-value pairs that specify an
"action" to perform for each property and corresponding helper information.  The
following actions can be used:

- **store**: indicates that the value of this property should be stored in the
  Chado database. This action requires the following key/value pairs:

  - **chado_table**: (required) the name of the table that this property will
    get stored in.
  - **chado_column**: (required) the name of the column in the table where This
    property value will get stored.
  - **fixed_value**: (optional) if the value of this field should never change
    and should be fixed at the provided value.
- **join**: indicates that the value of this property is obtained by joining
  the record specified in the `record_id` property with another table in Chado.

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

- **link**:  indicates that the value of this property is the ID of a linking
  table (e.g., a property table).

  - **chado_table**: (required) the name of the table that should be linked to the base
    table. For example, if the base table is `analysis` and you want to link to
    the `analysisprop` table, this would be `analysisprop`.
  - **chado_column**:  (required) the chado column that will house the value of this property.
    This should *always* be the primary key field of the linked table
    (e.g. `analysispropr_id`).
  - **link_column**: (required) the column in the `chado_table` that is the foreign key
    to the base table (e.g. `anslysis_id`).

- **replace**:  indicates that the value of this property is a tokenized string
  and should be replaced with values from other properties.

  - **template**: (required) a string containing the value of the field. The
    string should contain tokens that will be replaced by values of other properties.  Tokens are
    surrounded by square brackets and contain the keys of other properties. For example.
    if the keys for other properties are "genus", "species", "iftype", "ifname" you can
    create a property that builds the full scientific name of an organism with the
    following template string:
    "<i>[genus] [species]</i> [iftype] [ifname]".

- **function**:  indicates that the value of this property will be set by a
  callback function.

    - *Currently not implemented in Alpha release v1*

As an example, the following settings were used for property types in the organism field
of Tripal.

.. code:: php

    // Use the default settings for the `value` property.
    $value_settings = $settings['property_settings']['value'];

    // Use a tokenized string to build the organism label (full scientific name).
    $label_settings = [
      'action' => 'replace',
      'template' => "<i>[$genus_term] [$species_term]</i> [$iftype_term] [$ifname_term]",
    ];

    // Join to the organism table to get the genus.
    $genus_settings = [
      'action' => 'join',
      'path' => $base_table . '.organism_id>organism.organism_id',
      'chado_column' => 'genus'
    ];

    // Join to the organism table to get the species.
    $species_settings = [
      'action' => 'join',
      'path' => $base_table . '.organism_id>organism.organism_id',
      'chado_column' => 'species'
    ];

    // Join to the cvterm table via the organism table to get the infraspecific type.
    $iftype_settings = [
      'action' => 'join',
      'path' => $base_table . '.organism_id>organism.organism_id;organism.type_id>cvterm.cvterm_id',
      'chado_column' => 'name',
      'as' => 'infraspecific_type_name'
    ];

    // Join to the organism table to get the infraspecific name.
    $ifname_settings = [
      'action' => 'join',
      'path' => $base_table . '.organism_id>organism.organism_id',
      'chado_column' => 'infraspecific_name',
    ];



Implementing a TripalWidgetBase Class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Implementing a TripalFormatterBase Class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Automate Adding a Field to a Content Type
-----------------------------------------

What About Fields not for Chado?
--------------------------------
