Creating a Docker for Testing
=============================

This section describes the procedure to create and run a docker container from a specific branch from the Tripal repository. This is helpful for testing your own proposed changes, or testing another contributor's proposed changes, since the full install process will be performed on the branch.

Testing an unmerged pull request
--------------------------------

1. An unmerged pull request will be associated with a particular branch. You will see the branch name on the GitHub page for that pull request. Use this branch name in the following procedure. For example, it may appear as

        .. image:: docker.for.testing.branch.png

2. Change to a suitable working directory on your local test system.

3. The original issue number is part of the branch name, for clarity we will use it in the docker name. In the following examples we will use 9999, but use the appropriate issue number.

    .. code::

      git clone https://github.com/tripal/tripal tripal-9999
      cd tripal-9999

4. We will create the docker image, this takes a bit of time to complete.

    .. code::

      sudo docker build --tag=tripaldocker:testing-9999 --build-arg drupalversion="9.5.x-dev" --file tripaldocker/Dockerfile-php8.1-pgsql13 ./

5. We will now create a running docker container from this image, and map the web port to a value available on the test system.

    .. code::

      sudo docker run --publish=80:80 -tid --name=testing-9999 --volume=$(pwd):/var/www/drupal9/web/modules/contrib/tripal tripaldocker:testing-9999

   If you wanted to use a different port on the host system, for example 8080, just modify the publish part of the command:

    .. code::

      --publish=80:8080

6. And finally we need to start up Postgres inside the docker container.

    .. code::

      sudo docker exec testing-9999 service postgresql restart

7. The Tripal site should now be available to evaluate at http://localhost

8. If at some point you reboot your test system, you can restart this docker container with:

    .. code::

      sudo docker start testing-9999
      sudo docker exec testing-9999 service postgresql restart

9. Listing existing images

    .. code::

      sudo docker images
      REPOSITORY                   TAG            IMAGE ID       CREATED          SIZE
      tripaldocker                 testing-9999   6b09ee09dd54   29 minutes ago   1.61GB

10. Cleanup. Stopping the docker container.

    .. code::

      sudo docker stop testing-9999

11. Deleting the docker container and image when you are done with it.

    .. code::

      sudo docker rm testing-9999
      sudo docker rmi tripaldocker:testing-9999
