
Requirements
===============

- Drupal (see supported versions below)
- Drupal core modules: Search, Path, Views, and Field.
- PostgreSQL 10+
- PHP 8 (tested with 8.0 + 8.1)
- Apache 2+
- Composer 2+
- UNIX/Linux

.. note::

  Apache 2+ is recommended as the webserver but Drupal is also known to work well with Nginx. You may have limited support for Nginx from the Tripal community.

  PostgreSQL is required by Chado to function properly, rather than MySQL or any other database management system.

Supported Drupal Versions
---------------------------

The following table shows the current status of automated testing on the versions
of Drupal we currently support.

=========== ================ ================
Drupal      10.0.x           10.1.x
=========== ================ ================
**PHP 8.1** |PHP8.1D10.0.x|  |PHP8.1D10.1.x|
**PHP 8.2** |PHP8.2D10.0.x|  |PHP8.2D10.1.x|
=========== ================ ================


.. |PHP8.1D10.0.x| image:: https://github.com/tripal/tripal/actions/workflows/MAIN-phpunit-php8.1_D10_0x.yml/badge.svg
   :target: https://github.com/tripal/tripal/actions/workflows/MAIN-phpunit-php8.1_D10_0x.yml
.. |PHP8.1D10.1.x| image:: https://github.com/tripal/tripal/actions/workflows/MAIN-phpunit-php8.1_D10_1x.yml/badge.svg
   :target: https://github.com/tripal/tripal/actions/workflows/MAIN-phpunit-php8.1_D10_1x.yml
.. |PHP8.2D10.0.x| image:: https://github.com/tripal/tripal/actions/workflows/MAIN-phpunit-php8.2_D10_0x.yml/badge.svg
   :target: https://github.com/tripal/tripal/actions/workflows/MAIN-phpunit-php8.2_D10_0x.yml
.. |PHP8.2D10.1.x| image:: https://github.com/tripal/tripal/actions/workflows/MAIN-phpunit-php8.2_D10_1x.yml/badge.svg
   :target: https://github.com/tripal/tripal/actions/workflows/MAIN-phpunit-php8.2_D10_1x.yml
