---
layout: default-nav
title: Community
description: mlpack | fast, flexible C++ machine learning library
order: 3
---

## community

mlpack is a community-led effort, and so the code is not possible without the
community.  Since mlpack is an open-source project, anyone is welcome to beome a
part of the community and contribute.  There is no need to be a machine learning
expert to participate---often, there are many tasks to be done that don't
require in-depth knowledge.

Over the past several years, mlpack has participated in [Google Summer of
Code](https://summerofcode.withgoogle.com).  For more information, see [this
page](gsoc.html).

All mlpack development is done on [GitHub](https://github.com/mlpack/mlpack).
In addition to that, we use:

 * the [mlpack mailing list](http://lists.mlpack.org/mailman/listinfo/mlpack)
   for **email discussion and announcements**,
 * the [#mlpack](http://webchat.freenode.net/?channels=mlpack) IRC channel on
   freenode for **real-time chat and discussion** ([logs](http://www.mlpack.org/irc/)),
 * the [mlpack-git mailing list](http://lists.mlpack.org/mailman/listinfo/mlpack-git),
   which sends email for **all mlpack-related activity**.
 * the [mlpack blog](http://www.mlpack.org/blog/) for **mlpack development
   updates and blog posts**

## getting involved

Everyone is welcome to contribute to mlpack.  But before becoming a contributor,
it's often useful to understand mlpack as a user.  So, a good place to start is
to [download mlpack](index.html) and use the
[Python bindings](doc/mlpack-3.1.0/python_documentation.html) or the
[command-line programs](doc/mlpack-3.1.0/cli_documentation.html) to perform machine learning
tasks.  You can also write C++ programs to perform machine learning tasks with
mlpack; [here](doc/mlpack-3.1.0/doxygen/sample.html) are some basic examples.

Once you have an idea of what's included in mlpack and how a user might use it,
then a good next step would be to set up a development environment.  Once you
have that set up, you can [build mlpack from
source](doc/mlpack-3.1.0/doxygen/build.html) and [explore the
codebase](https://github.com/mlpack/mlpack/) to see how it's organized.  It may
even be useful to try and make small changes to the code, then rebuild the
command-line programs and see what your changes did.

Now you're set up to contribute!  There are lots of ways you can contribute.
Here are a couple ideas:

 * Help others figure out their mlpack issues and questions.
   [Here](https://github.com/mlpack/mlpack/issues?q=is%3Aopen+is%3Aissue+label%3A%22t%3A+question%22)
   is a list of Github issues tagged `question`.  Helping others figure out
   their problems is really one of the best ways to learn about the library.

 * Find an issue that needs implementation help;
   [here](https://github.com/mlpack/mlpack/issues?q=is%3Aopen+is%3Aissue+label%3A%22help+wanted%22)
   is a list of Github issues tagged `help wanted`; and
   [here](https://github.com/mlpack/mlpack/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22)
   is a list of Github issues tagged `good first issue`.  Once you open a PR
   that passes all the continuous integration tests, the community will review
   it and get it merged into the codebase.

 * Find an abandoned pull request;
   [here](https://github.com/mlpack/mlpack/pulls?q=is%3Aclosed+is%3Apr+label%3A%22s%3A+stale%22)
   is a list of pull requests that were closed for inactivity.  Often these have
   comments that need to be addressed, but the original author didn't have time
   to finish the work.  So, you can pick up where they left off!

 * Implement a new machine learning algorithm that mlpack doesn't currently
   have.

 * Take a look at the ideas on the Google Summer of Code
   [Ideas List](https://github.com/mlpack/mlpack/wiki/SummerOfCodeIdeas) and see
   if you find any of them interesting or exciting.  Even if you're not planning
   to do Summer of Code, it's okay to take these ideas and implement them
   separately.

 * Do some timing on an existing machine learning algorithm implemented by
   mlpack, and try to make it faster.

 * If you find a bug or have a problem,
   [open an issue](https://github.com/mlpack/mlpack) for it---issue templates
   are provided to make reporting easier.

## developers

Below is a list of contributors to mlpack.  Without their hard work, this
software would not be possible.

{% include_relative contributors.md %}
