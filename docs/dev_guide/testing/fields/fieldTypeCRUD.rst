Testing FieldType classes through CRUD operations
====================================================

.. warning::

  All the following will assume you are developing these tests using the TripalDocker, with your module fully installed and mounted within the docker. For instructions on how to set this up see :doc:`Install with TripalDocker </install/docker>` documentation. In all the commands with CONTAINERNAME, replace it with the name of your container.

Creating your testing FieldType Test Class
-------------------------------------------

All tests are encapsulated within their own class as dictated by PHPunit. As such lets create a class skeleton as follows:

In `[yourmodule]/tests/src/Kernel/Plugin/ChadoField/FieldType` create a file with a descriptive name for your test. We recommend naming it using the following pattern `[FieldName]Test.php`. The "Test" suffix is required by PHPUnit so make sure to at least include that in your test name or the test runner will not be able to find your test.
