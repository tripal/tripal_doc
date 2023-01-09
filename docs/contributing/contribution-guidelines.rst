Guidelines for Contribution to Tripal
========================================

The following guidelines are meant to encourage contribution to Tripal source-code on GitHub by making the process open, transparent and collaborative. If you have any feedback including suggestions for improvement or constructive criticism, please `comment on the Github issue <https://github.com/tripal/tripal/issues/344>`_. **These guidelines apply to everyone contributing to Tripal whether it's your first time (Welcome!) or project management committee members.**

.. note::

  These guidelines are specifically for contributing to `Tripal <https://github.com/tripal/tripal>`_. However, we encourage all Tripal extension modules to consider following these guidelines to foster collaboration among the greater Tripal Community.

.. note::

  Guidelines serve as suggestions ( **should** ) or requirements (**must**). When the word "should" is used in the text below, the stated policy is expected but there may be minor exceptions.  When the word "must" is used there are no exceptions to the stated policy.


Github Communication Tips
---------------------------

- Don't be afraid to mention people (@username) who are knowledgeable on the topic or invested.  *We are academics and overcommitted, it's too easy for issues to go unanswered: don't give up on us!*
- Likewise, don't be shy about bumping an issue if no one responds after a few days. *Balancing responsibilities is hard.*
- Want to get more involved? Issues marked with "Good beginner issue" are a good place to start if you want to try your hand at submitting a PR.
- Everyone is encouraged/welcome to comment on the issue queue! Tell us if you
    - are experiencing the same problem
    - have tried a suggested fix
    - know of a potential solution or work-around
    - have an opinion, idea or feedback of any kind!
- Be kind when interacting with others on Github! (see Code of Conduct below for further guidelines). We want to foster a welcoming, inclusive community!
    - Constructive criticism is welcome and encouraged but should be worded such that it is helpful :-) Direct criticism towards the idea or solution rather than the person and focus on alternatives or improvements.

Pull Request (PR) Guideline
----------------------------

The goal of this document is to make it easy for **A)** contributors to make pull requests that will be accepted, and **B)** Tripal committers to determine if a pull request should be accepted.

- PRs that address a specific issue **must** link to the related issue page.
    - In almost every case, there should be an issue for a PR.  This allows feedback and discussion before the coding happens.  Not grounds to reject, but encourage users to create issues at start of their PR.  Better late than never :).
- PRs **must** be left unmerged for 3 weekdays to give core developers a chance to learn from each other and provide any feedback. Larger or particularly important/interesting PRs should be announced in the Slack #core-dev channel.
- PRs **must** describe what they do and provide manual testing instructions.
- PRs **must not** use any functions deprecated in the currently supported version of Drupal.
- PRs that include new functionality **must** also provide Automated Testing.
    - A PR should not reduce the overall test coverage of the repository. Code Climate will comment on your PR with the total coverage in the repository and include the change caused by your PR. This change must not be negative.
    - .. image:: contribution-guidelines.testcoverageexample.png
- PRs **must** pass all automated testing marked as "Required" at the bottom of the PR.
- Branches **must** follow the following format:
    - ``tv4g[0-9]-issue\d+-[optional short descriptor]``
    - See the shared repository documentation for more details.
- **Should** follow `Drupal code standards <https://www.drupal.org/docs/develop/standards>`_

How to create a PR
^^^^^^^^^^^^^^^^^^^^^

There are great instructions on creating a PR on `Digital Ocean: How To Create a Pull Request on GitHub <https://www.digitalocean.com/community/tutorials/how-to-create-a-pull-request-on-github>`_.

**The tl;dr version:**

1. `Fork the repository <https://docs.github.com/en/github/getting-started-with-github/fork-a-repo>`_ or `update an existing fork <https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/syncing-a-fork>`_
2. `Clone <https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository>`_ the fork
3. `Create a branch <https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging>`_ specific to your change: ``tv4g[0-9]-issue\d+-[optional short descriptor]``
4. Make your changes, `committing <https://git-scm.com/docs/git-commit#_examples>`_ often with useful commit messages.
5. `Push <https://git-scm.com/docs/git-push#_examples>`_ your changes to your fork.
6. `Create a PR by going to your fork <https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork>`_: target should be ``tripal:9.x-4.x``. For specifics, see guidelines above.

.. note:

  If you are a `committer <>`_, you can clone the Tripal repository directly with no need to create or maintain a fork. Please make sure you are always creating new branches off of ``9.x-4.x`` and that you have pulled all recent changes to ``9.x-4.x`` before creating a new branch.
