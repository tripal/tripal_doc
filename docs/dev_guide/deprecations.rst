
Deprecations in Tripal 4.x
==========================

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   deprecations/chado_query_api
   deprecations/chado_variables_api
   deprecations/chado_cv_api
   deprecations/chado_db_api

Several of Tripal 4.x's functions have been modified, deprecating their older versions.
While it is ok to use that code at the moment, legacy code may/will disappear in future releases. Before Tripal 4.x developers reuse code of the deprecated legacy functions, they need to be aware of the deprecated status of the function.
This section describes how to handle deprecations in Tripal 4.x.
It gives a list of functions that are deprecated in Tripal 4.x and
possibly provide alternate functions to use in their place.

For example, replacements for **db_\*** functions use Drupal's object oriented querying engine.

The BioDB API
-------------

The new BioDB API in Tripal 4.x extends the Drupal Database API to handle multiple PostgreSQL schema and cross-schema querying thereby integrating Tripal and Chado. Specifically, this allows us to use the Drupal style of querying with Chado as shown in the following example:

.. code-block:: php

  // Initiate the new Tripal BioDB service with Chado integration.
  $biodb = \Drupal::service('tripal_chado.database');
  // Start a select query on the feature table.
  $query = $biodb->select('feature', 'x');
  // Add JOINS to the organism and cvterm tables.
  $query->join('organism', 'o', 'x.organism_id = o.organism_id');
  $query->join('cvterm', 'cvt', 'x.type_id = cvt.cvterm_id');
  // Exclude obsolete features.
  $query->condition('x.is_obsolete', 'f', '=');
  // Add the columns you want to be returned.
  $query->fields('x', ['name', 'uniquename']);
  $query->fields('o', ['genus', 'species', 'common_name']);
  $query->addField('cvt', 'name', 'feature_type');
  // Indicate the range of results you want.
  $query->range(0, 10);
  // Finally execute the above build query.
  $result = $query->execute();
  foreach ($result as $record) {
    // Do something with each record from the chado database.
  }


Which would be the equivalent of the following Chado SQL Query:

.. code-block:: sql

  SELECT x.name, x.uniquename, cvt.name as feature_type, o.genus, o.species, o.common_name
  FROM chado.feature x
  LEFT JOIN chado.organism o ON x.organism_id = o.organism_id
  LEFT JOIN chado.cvterm cvt ON x.type_id = cvt.cvterm_id
  WHERE x.is_obsolete = f
  LIMIT 10;

Static query example on feature table in default Chado schema
-------------------------------------------------------------

.. code-block:: php

  $biodb = \Drupal::service('tripal_chado.database');
  $sql_query = 'SELECT name, residues FROM {1:feature} x WHERE x.is_obsolete = :obsolete LIMIT 0, 10;';
  $results = $biodb->query($sql_query, [':obsolete' => 'f']);
  foreach ($results as $record) {
    echo $record->name . "\n";
  }


Cross schema queries
--------------------

.. code-block:: php

  $biodb = \Drupal::service('tripal_chado.database');
  $biodb->setSchemaName('chado1');
  $biodb->addExtraSchema('chado2');
  $sql = "
    SELECT * FROM
      {1:feature} f1,
      {2:feature} f2,
      {node_field_data} fd
    WHERE fd.title = f1.uniquename
      AND f1.uniquename = f2.uniquename;";
  $results = $biodb->query($sql);


.. note::

  If a developer finds that a function not mentioned here is deprecated, 
  please add an issue on our github at 
  https://github.com/tripal/tripal_doc/issues !

Additional Resources
--------------------

 - `Official Drupal: db_* procedural functions of the Database API layer have been deprecated <https://www.drupal.org/node/2993033>`_
 - `Official Drupal: function db_select <https://api.drupal.org/api/drupal/core%21includes%21database.inc/function/db_select/8.9.x>`_
 - `Issue 1781 <https://github.com/tripal/tripal/issues/1781>`_ Add deprecation notices to legacy code
 - `Issue 1341 <https://github.com/tripal/tripal/issues/1341>`_ Deprecate existing Chado Query API in favour of new BioDB API
 - `Issue 1342 <https://github.com/tripal/tripal/issues/1342>`_ Deprecate existing ChadoRecord + ChadoSchema classes in favour of Tripal BioDB
 - `Issue 1343 <https://github.com/tripal/tripal/issues/1343>`_ Deprecated Functions in Tripal 4
 - `Issue 1646 <https://github.com/tripal/tripal/issues/1646>`_ Move function-focused legacy API into a separate core submodule
 - `Drupal's how to deprecate <https://www.drupal.org/about/core/policies/core-change-policies/drupal-deprecation-policy#how>`_

