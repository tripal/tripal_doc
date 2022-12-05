How run automated tests locally
=================================

We highly recommend running the automated testing suite using Tripal Docker to ensure your environment is set-up properly for testing and to mimic the environment of the tests run on GitHub as closely as possible.

Using Tripal Docker
--------------------

If you are using the docker distributed with this module, then you can run tests using the following command after changing `CONTAINERNAME` to the name of your current container.

.. code:: bash

  docker exec --workdir=/var/www/drupal9/web/modules/contrib/tripal CONTAINERNAME phpunit

.. note::

  To first set-up Tripal Docker, see these docs: :doc:`/install/docker`.

  To summarize, run the following command and then use `tripal4` as the `CONTAINERNAME` above.

  .. code:: bash

    docker run --publish=9000:80 --name=tripal4 -tid tripalproject/tripaldocker:latest

In a Local Development Environment
------------------------------------

See the `Drupal "Running PHPUnit tests" guide <https://www.drupal.org/node/2116263>`_ for instructions on how to setup your local environment for running tests. This requires installing a specific Drupal composer file to ensure you have the required packages installed.

To run the Tripal test suite, navigate to the tripal directory and run `phpunit`.
