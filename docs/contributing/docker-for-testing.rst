Creating a Docker for Testing
=============================

This section describes the procedure to create and run a docker container from a specific branch from the Tripal repository. This is helpful for testing your own proposed changes, or testing another contributor's proposed changes, since the full install process will be performed on the branch.

Testing on the most current development version
-----------------------------------------------

To create a docker incorporating the very latest updates to Tripal, you can use the 


Testing an unmerged pull request
--------------------------------

1. `Install Docker <https://docs.docker.com/get-docker>`_ for your system.

2. Change to a suitable working directory on your local test system.

3. Clone the most recent version of Tripal 4 keeping track of where you cloned it. To keep things organized, you may want to include the issue number, here it is 9999:

  .. code-block:: bash

    git clone https://github.com/tripal/tripal tripal-9999
    cd tripal-9999

4. If you want to contribute to core, you always want to make a new branch, do not work directly on the 4.x branch. Use following naming convention for branches: ``tv4g[0-9]-issue\d+-[optional short descriptor]``.

  - ``tv4g[0-9]`` indicates the functionality group the branch relates to. See tags for groups available.
  - ``issue\d+`` indicates the issue describing the purpose of the branch. By making a new issue for each major task before we start working on it, we give  room for others to jump in and save you time if something is already done, beyond scope, or can be made easier by something they are working on!
  - ``[optional short descriptor]`` can be anything without spaces. This is meant to make the branches more readable so we don’t have to look up the issue every time. You are encouraged to only have one branch per issue! That said, there are some edge-cases where multiple branches may be needed (i.e. partitioned reviews) where variations in the optional short description can make the purpose of multiple branches clear.

  Example for creating a new branch for creating a new field. Base your new branch on the main 4.x branch:

  .. code-block:: bash

    git checkout 4.x
    git branch tv4g1-issue1414-some_new_field
    git checkout -b tv4g1-issue1414-some_new_field

  Or if you want to test an unmerged pull request, it will be associated with a particular branch. You will see the branch name on the GitHub page for that pull request. Use this branch name in the following procedure. For example, it may appear as

  .. image:: docker.for.testing.branch.png

  .. code-block:: bash

    git checkout -b tv4g1-issue1449-chadostorage-linkertables

  If the contributor's branch is in their own repository, checking it out will be slightly different, you will need to include the pull request number. For example, for pull request #1535:

  .. code-block:: bash

    git fetch origin pull/1535/head:tv4g2-issue1534-chadoCvtermAutocompleteUpdate

5. We will create the docker image, this takes a bit of time to complete. You may want to specify a particular drupal version, php version, or PostgresQL version. The PHP version is part of the docker file name, the other versions are specified through the --build-arg parameters. For example:

    .. code::

      sudo docker build --tag=tripaldocker:testing-9999 --build-arg drupalversion="10.2.x-dev" --build-arg postgresqlversion="15" --file tripaldocker/Dockerfile-php8.3 ./

6. We will now create a running docker container from this image, and map the web port to a value available on the local test system. For example, we will select port 8080:

    .. code::

      sudo docker run --publish=8080:80 -tid --name=testing-9999 --volume=$(pwd):/var/www/drupal9/web/modules/contrib/tripal tripaldocker:testing-9999

7. And finally we need to start up Postgres inside the docker container.

    .. code::

      sudo docker exec testing-9999 service postgresql restart

8. The Tripal site should now be available to evaluate at http://localhost:8080 or whatever other port you selected.

9. If you need a shell inside the docker, such as to run a drush command, use

    .. code::

      sudo docker exec -it testing-9999 /bin/bash

10. If at some point you reboot your test system, you can restart this docker container with:

    .. code::

      sudo docker start testing-9999
      sudo docker exec testing-9999 service postgresql restart

11. Listing existing images

    .. code::

      sudo docker images
      REPOSITORY                   TAG            IMAGE ID       CREATED          SIZE
      tripaldocker                 testing-9999   6b09ee09dd54   29 minutes ago   1.61GB

12. Cleanup. Stopping the docker container.

    .. code::

      sudo docker stop testing-9999

13. Deleting the docker container and image when you are done with it.

    .. code::

      sudo docker rm testing-9999
      sudo docker rmi tripaldocker:testing-9999

For more details about TripalDocker including the site administrator login information and more usage commands see :ref:`the install Tripal using Docker usage section<Development Site Information:>`.
