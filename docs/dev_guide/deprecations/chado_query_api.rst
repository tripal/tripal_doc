
Tripal Chado Query API is deprecated in favour of the Tripal DBX Query API
==============================================================================

- **Deprecated in** tripal 4.0.0-alpha3
- **Removed in** tripal 4.1.0
- **Issue** `#1314 <https://github.com/tripal/tripal/issues/1341>`_
- **PR** `#2294 <https://github.com/tripal/tripal/pull/2294>`_

The `Drupal Database API <https://www.drupal.org/docs/develop/drupal-apis/database-api>`_ provides a unified, object-oriented approach to querying databases that provides support for a large number of underlying database engines (e.g. MySQL, MongoDb, SQLlite, PostgreSQL). It is built upon PHP's PDO (PHP Data Objects) database API, and inherits much of its syntax and semantics. Tripal DBX extends the Drupal Database API to provide support specific to handling multiple schemas in PostgreSQL, as well as, to provide awareness of the Chado Schema.

This change record marks the point that the old function-based Tripal Chado Query API will be deprecated in favour of this new object-oriented approach fully integrated with Drupal 9+.

chado_query()
---------------

The chado_query() function was created to support use of an SQL query with placeholders on the chado database. This function is now handled via the Tripal DBX Query API. There is an example below showing a complex query across multiple Chado tables and contrasting it with the new approach. You should notice that they are very similar with a main difference being the surrounding of table names with `{1: tablename}` within the query in the new approach. This ensures that schema replacement can be done much more reliably and supports multiple chado schema.

**Before:**

.. code-block:: php

  $sql = "SELECT F.name, CVT.name as type_name, ORG.common_name
         FROM feature F
         LEFT JOIN cvterm CVT ON F.type_id = CVT.cvterm_id
         LEFT JOIN organism ORG ON F.organism_id = ORG.organism_id
         WHERE
           F.uniquename = :feature_uniquename";
  $args = [
    ':feature_uniquename' => $form_state['values']['uniquename']
  ];
  $result = chado_query( $sql, $args );
  foreach ($result as $r) {
    // Do something with the records here.
  }

**After:**

.. code-block:: php

  $sql = "SELECT F.name, CVT.name as type_name, ORG.common_name
         FROM {1:feature} F
         LEFT JOIN {1:cvterm} CVT ON F.type_id = CVT.cvterm_id
         LEFT JOIN {1:organism} ORG ON F.organism_id = ORG.organism_id
         WHERE
           F.uniquename = :feature_uniquename";
  $args = [
    ':feature_uniquename' => $form_state['values']['uniquename']
  ];
  $result = \Drupal(tripal_chado.database)->query($sql, $args);
  foreach ($result as $r) {
    // Do something with the records here.
  }


chado_select_record()
-----------------------

Tripal DBX now provides an object-oriented approach to selecting a record that better supports selecting across multiple tables and complex conditions. The following example shows how you can update using chado_record_select() to select all genes with a given organism using TripalDBX.

**Before:**

.. code-block:: php

  $values =  array(
    'organism_id' => array(
        'genus' => 'Citrus',
        'species' => 'sinensis',
    ),
    'type_id' => array(
        'cv_id' => array(
          'name' => 'sequence',
        ),
        'name' => 'gene',
        'is_obsolete' => 0
    ),
  );
  $result = chado_select_record(
    'feature',                      // table to select from
    array('name', 'uniquename'),    // columns to select
    $values                         // record to select (see variable defn. above)
  );

**After:**

.. code-block:: php

  $query = \Drupal('tripal_chado.database')->select('1:feature', 'f')
    ->fields('f', ['name','uniquename'])
    ->join('organism', 'o', 'o.organism_id = f.organism_id')
    ->condition('o.genus', 'Citrus', '=')
    ->condition('o.species', 'sinensis', '=')
    ->join('cvterm', 'cvt', 'cvt.cvterm_id = f.type_id')
    ->condition('cvt.name', 'gene', '=');
  $result = $query->execute();
  foreach ($result as $record) {
    // Do something with the $record object here.
    // e.g. echo $record->name;
  }

chado_insert_record()
----------------------

Tripal DBX insert uses the same syntax and supports all the same functionality as the Drupal Database API does. As such you can find more information on the new syntax in `the official Drupal docs on insert() <https://www.drupal.org/docs/drupal-apis/database-api/insert-queries>`_. Additionally, you can find more information on Tripal DBX including specific chado examples `in our own documentation <https://tripaldoc.readthedocs.io/en/latest/dev_guide/biodata/tripaldbx.html>`_.

The following example shows how you would insert a gene before using `chado_insert_record()` and now using Tripal DBX. You will notice that a complicated insert which needs to lookup a number of values takes a separate query now. In the future we will extend chado buddies to a lot of these cases but in the meantime we still recommend using Tripal DBX as the old `chado_insert_record()` is not only very slow but also no longer maintained.

**Before:**

.. code-block:: php

  $values =  array(
    'organism_id' => array(
        'genus' => 'Citrus',
        'species' => 'sinensis',
    ),
    'name' => 'orange1.1g000034m.g',
    'uniquename' => 'orange1.1g000034m.g',
    'type_id' => array (
        'cv_id' => array (
          'name' => 'sequence',
        ),
        'name' => 'gene',
        'is_obsolete' => 0
    ),
  );
  $result = chado_insert_record(
    'feature',             // table to insert into
    $values                // values to insert
  );

**After:**

.. code-block:: php

  $chado_connection = \Drupal('tripal_chado.database');
  // First we have to select the organism id.
  $organism_query = $chado_connection->select('1:organism', 'o')
    ->fields('o', ['organism_id'])
    ->condition('o.genus', 'Citrus', '=')
    ->condition('o.species', 'sinensis', '=');
  $organism_id = $organism_query->execute()->fetchField();
  // Then we have to get the type id for gene.
  // We suggest you use the chado buddies for this and as such will not
  // include an example here. You could also use Tripal DBX but it's ideal
  // to select cvterms using the dbxref.accession and db.name which makes
  // for a fair number of joins.
  $type_id = 123;
  // Finally we can call the insert.
  $query = $connection->insert('1:feature', 'f')
    ->fields([
      'name' => 'orange1.1g000034m.g',
      'uniquename' => 'orange1.1g000034m.g',
      'organism_id' => $organism_id,
      'type_id' => $type_id,
    ])
    ->execute();

chado_update_record()
----------------------

Tripal DBX update uses the same syntax and supports all the same functionality as the Drupal Database API does. As such you can find more information on the new syntax in `the official Drupal docs on update() <https://www.drupal.org/docs/drupal-apis/database-api/update-queries>`_. Additionally, you can find more information on Tripal DBX including specific chado examples `in our own documentation <https://tripaldoc.readthedocs.io/en/latest/dev_guide/biodata/tripaldbx.html>`_.

The following example shows how you would update a specific genes name and type before using `chado_update_record()` and now using Tripal DBX. Just as with insert above, we need to query the organism_id and types before we can formulate our update query. See `chado_select_record()` above for more information on doing this.

**Before:**

.. code-block:: php

  $umatch = array(
    'organism_id' => array(
      'genus' => 'Citrus',
      'species' => 'sinensis',
    ),
    'uniquename' => 'orange1.1g000034m.g7',
    'type_id' => array (
      'cv_id' => array (
        'name' => 'sequence',
      ),
      'name' => 'gene',
      'is_obsolete' => 0
    ),
  );
  $uvalues = array(
    'name' => 'orange1.1g000034m.g',
    'type_id' => array (
      'cv_id' => array (
        'name' => 'sequence',
      ),
      'name' => 'mRNA',
      'is_obsolete' => 0
    ),
  );
  $result = chado_update_record('feature',$umatch,$uvalues);

**After:**

.. code-block:: php

  // Just as with insert we need to lookup the organism_id and the types.
  // For simplicity of this example, we will just use variables here.
  // Values to match the original record we want to update.
  $umatch = [
    'organism_id' => $organism_id,
    'uniquename' => 'orange1.1g000034m.g7',
    'type_id' => $gene_typeid,
  ];
  // Values we want to update this record to have.
  $uvalues = array(
    'name' => 'orange1.1g000034m.g',
    'type_id' => $mrna_typeid,
  );
  $update_query = \Drupal('tripal_chado.database')->update('1:feature')
    ->fields($uvalues);
  // We are going to use a loop to each item in the array as a condition.
  foreach ($umatch as $column_name => $value) {
    $update_query->condition($column_name, $value, '=');
  }
  $update_query->execute();

chado_delete_record()
----------------------

The following example shows how you would delete all Citrus sinensis genes before using `chado_delete_record()` and now using Tripal DBX. Just as with insert and update above, we need to query the organism_id and type_id before we can formulate our delete query. See `chado_select_record()` above for more information on doing this.

Tripal DBX delete uses the same syntax and supports all the same functionality as the Drupal Database API does. As such you can find more information on the new syntax in `the official Drupal docs on delete() <hhttps://www.drupal.org/docs/drupal-apis/database-api/delete-queries>`_. Additionally, you can find more information on Tripal DBX including specific chado examples `in our own documentation <https://tripaldoc.readthedocs.io/en/latest/dev_guide/biodata/tripaldbx.html>`_.

**Before:**

.. code-block:: php

  $values =  array(
    'organism_id' => array(
        'genus' => 'Citrus',
        'species' => 'sinensis',
    ),
    'type_id' => array (
        'cv_id' => array (
          'name' => 'sequence',
        ),
        'name' => 'gene',
        'is_obsolete' => 0
    ),
  );
  $result = chado_select_record(
    'feature',                      // table to select from
    $values                         // records to delete (see variable defn. above)
  );


**After:**

.. code-block:: php

  // Just as with insert we need to lookup the organism_id and the types.
  // For simplicity of this example, we will just use variables here.
  $query = \Drupal('tripal_chado.database')->delete('1:feature', 'f')
    ->condition('organism_id', $organism_id, '=')
    ->condition('type_id', $type_id, '=')
    ->execute();
