---
layout: default-nav
title: Community
displaytitle: Community
description: mlpack | fast, flexible C++ machine learning library
order: 4
---

<div class="page-title-header">Community</div>

mlpack is a community-led effort, and so the code is not possible without the
community.  Since mlpack is an open-source project, anyone is welcome to become a
part of the community and contribute.  There is no need to be a machine learning
expert to participate---often, there are many tasks to be done that don't
require in-depth knowledge.

Over the past several years, mlpack has participated in [Google Summer of
Code](https://summerofcode.withgoogle.com).  For more information, see [this
page](gsoc.html).

All mlpack development is done on [GitHub](https://github.com/mlpack/mlpack).
In addition to that, there are a few channels of communication:

### mlpack mailing lists

Two mailing lists are used for mlpack discussion and development:

<ul class="flex-container">
  <li class="flex-item">
    <div class="card">
      <a href="http://lists.mlpack.org/mailman/listinfo/mlpack" class="card-global-link"/>
      <i class="far fa-envelope fa-lg card-icon"></i>
      <p><a>mlpack mailing list</a></p><p>for email discussion and announcements</p>
    </div>
  </li>

  <li class="flex-item">
    <div class="card">
      <a href="#real-time-chat" class="card-global-link"/>
      <i class="far fa-comments fa-lg card-icon"></i>
      <p><a href="">mlpack real-time chat</a></p><p>available through multiple services</p>
    </div>
  </li>

  <li class="flex-item">
    <div class="card">
      <a href="http://lists.mlpack.org/mailman/listinfo/mlpack-git" class="card-global-link"/>
      <i class="fab fa-git-square fa-lg card-icon"></i>
      <p><a href="">mlpack-git mailing list</a></p><p>which sends email for all mlpack-related activity</p>
    </div>
  </li>

  <li class="flex-item">
    <div class="card">
      <a href="http://www.mlpack.org/blog/" class="card-global-link"/>
      <i class="far fa-newspaper fa-lg card-icon"></i>
      <p><a href="">Blog</a></p><p>for mlpack development updates and blog posts</p>
    </div>
  </li>
</ul>

## getting involved

Everyone is welcome to contribute to mlpack.  But before becoming a contributor,
it's often useful to understand mlpack as a user.  So, a good place to start is
to [download mlpack](index.html) and use the
[Python bindings](doc/mlpack-3.4.2/python_documentation.html),
[R bindings](doc/mlpack-3.4.2/r_documentation.html),
[Julia bindings](doc/mlpack-3.4.2/julia_documentation.html), or the
[command-line programs](doc/mlpack-3.4.2/cli_documentation.html) to perform machine learning
tasks.  You can also write C++ programs to perform machine learning tasks with
mlpack; [here](doc/mlpack-3.4.2/doxygen/sample.html) are some basic examples.

Once you have an idea of what's included in mlpack and how a user might use it,
then a good next step would be to set up a development environment.  Once you
have that set up, you can [build mlpack from
source](doc/mlpack-3.4.2/doxygen/build.html) and [explore the
codebase](https://github.com/mlpack/mlpack/) to see how it's organized.  It may
even be useful to try and make small changes to the code, then rebuild the
command-line programs and see what your changes did.

Now you're set up to contribute!  There are lots of ways you can contribute.
Here are a couple ideas:

 * Help others figure out their mlpack issues and questions.
   [Here](https://github.com/mlpack/mlpack/issues?q=is%3Aopen+is%3Aissue+label%3A%22t%3A+question%22)
   is a list of Github issues tagged `question`.  Helping others figure out
   their problems is really one of the best ways to learn about the library.

 * Read through the [vision document](papers/vision.pdf) to learn about the
   development goals of the mlpack community and see the high-level tasks that
   need to be done to accomplish that vision.

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

## real-time chat

The mlpack community stays in touch in real-time via several chat services that are
all linked together thanks to the [Matrix project](http://www.matrix.org/). You can choose
any of the services below and will be able to communicate with anyone who is using any of
the other services (assuming that the inter-service bridges are correctly operating).

IRC via freenode: [#mlpack](http://webchat.freenode.net/?channels=mlpack); you can use webchat (the link), or set up an account on freenode and use a client of your choice.

Gitter: [mlpack/mlpack](https://gitter.im/mlpack/mlpack); you will need a Github account

Matrix: [#mlpack:matrix.org](https://matrix.org/); you will need to set up a matrix.org account and use a client such as [Element](https://element.io) or others.

Slack: [mlpack.slack.org](https://mlpack.slack.org/); in order to create an account, you’ll need to use the auto-inviter to send yourself an invite: [slack-inviter.mlpack.org](http://slack-inviter.mlpack.org:3000/).

Discussions in the chat channel are [logged](https://www.mlpack.org/irc/).

### video meet-up

On the first and third Thursday of every month, at *1800 UTC* on Thursdays, we
have casual _video meetups_ with no particular agenda.  Feel free to join up!
We often talk about code changes that we are working on, issues people are
having with mlpack, general design direction, and whatever else might be on our
mind.  We use [this Zoom room](https://zoom.us/j/3820896170).  For security, we
use a password for the meeting to keep malicious bots out; the password is
simple---it's just the name of the library (in all lowercase).

## developers

Below is a list of contributors to mlpack.  Without their hard work, this
software would not be possible.

{% include_relative contributors.md %}
