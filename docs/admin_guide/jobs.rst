Tripal Jobs
===========

Tripal comes with a robust job system for running on-demand or scheduled jobs. These jobs can be run manually or automatically using the Tripal Job Daemon.


Manual Job Execution
--------------------

Overview
^^^^^^^^

At various times, you may be given a command to run in order to launch a job. For example, when initially setting up the site to install and prepare Chado, or when using of the importers. The command will typically take this form:

  .. code-block:: shell

      drush trp-run-jobs --job_id=2 --username=admin --root=/var/www/tripal4/web

Let's break that down:

  - ``trp-run-jobs``

      This is the command. There are other commands available, see the section below.

  - ``--job_id=2``

      This specifies which job in the queue that will run.

  - ``--username=admin``

      This is the username of the owner of the job. This is important as it can help track down changes made to the site.

  - ``--root=/var/www/tripal4/web/``

      This is the root directory of the current Drupal site. This is especially important to specify when multiple sites are installed.

Commands and Arguments
^^^^^^^^^^^^^^^^^^^^^^

There are two main Drush commands related to the Tripal Job system:

  - ``trp-run-jobs``

      This command will run jobs that are on the queue. If the `job_id` flag is provided, it will run that specific job, otherwise it will run all jobs that are on the queue in chronological order based on when they were submitted. The following arguments are available:

        - ``job_id`` [optional] - Specify the number (id) of the job that is to be run.
        - ``username`` [required] - Specify the username of the person who is running the job.
  - ``trp-rerun-job`` — This command will rerun a specified job. The `job_id` flag is required.

The following is a list of arguments

Automating Job Execution
------------------------

Currently, running jobs automatically is not supported. This functionality will come with the upgrade of the Tripal Daemon module.
