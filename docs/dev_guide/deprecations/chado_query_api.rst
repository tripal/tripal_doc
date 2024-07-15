
Deprecations in tripal_chado.query.api.inc
==========================================

.. warning::
  This documentation is still under development and is not complete.

Previous database storage and access functions are all replaced by Tripal DBX. 
For example, to replace **db_select** one should move to 

**\Drupal::service('tripal_chado.database')->select()**

See below the table of the deprecated functions with their new alternatives in 
tripal_chado/src/api/tripal_chado.query.api.inc

.. table:: List of deprecated functions and corresponding new method

    +--------------------------------------+---------------------+
    | Deprecated function                  |    New method       |
    +======================================+=====================+
    | chado_db_select                      |                     |
    +--------------------------------------+---------------------+
    | chado_delete_record                  |                     |
    +--------------------------------------+---------------------+
    | chado_get_table_max_rank             |                     |
    +--------------------------------------+---------------------+
    | chado_insert_record                  |                     |
    +--------------------------------------+---------------------+
    | chado_pager_get_count                |                     |
    +--------------------------------------+---------------------+
    | chado_pager_query                    |                     |
    +--------------------------------------+---------------------+
    | chado_query                          |                     |
    +--------------------------------------+---------------------+
    | chado_schema_get_foreign_key         |                     |
    +--------------------------------------+---------------------+
    | chado_select_record                  |                     |
    +--------------------------------------+---------------------+
    | chado_select_record_check_value_type |                     |
    +--------------------------------------+---------------------+
    | chado_set_active                     |                     |
    +--------------------------------------+---------------------+
    | chado_update_record                  |                     |
    +--------------------------------------+---------------------+
    | hook_chado_connection_alter          |                     |
    +--------------------------------------+---------------------+
    | hook_chado_get_schema_name_alter     |                     | 
    +--------------------------------------+---------------------+
    | chook_chado_query_alter              |                     |
    +--------------------------------------+---------------------+

For general information on deprecations in Tripal 4.x refer to 

 - :ref:`Deprecations in Tripal 4.x`
