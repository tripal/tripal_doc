Database Queries
===================

db_query
-----------
The `db_query` function is deprecated in Drupal 9. To perform a database query you will need to rework any calls to the `db_query` function in the following way:

.. code-block:: php

    // Get the database object.
    $database = \Drupal::database();

    // Perform the query by passing the SQL statement and arguments.
    $query = $database->query($sql, $args);

    // Get the result(s).
    $job = $query->fetchObject();


drupal_write_record
-----------------------
The `drupal_write_record` was useful in Drupal 7 for directly working with tables that Drupal was aware of.  Here's the replacement:


.. code-block:: php

   $database = \Drupal::database();
   $num_updated = $database->update('tripal_jobs')
     ->fields([
       'status' => 'Cancelled',
       'progress' => 0,
     ])
     ->condition('job_id', $this->job->job_id)
     ->execute();

