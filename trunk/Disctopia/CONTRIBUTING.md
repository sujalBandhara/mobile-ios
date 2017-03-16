Contributing Guidelines
--------------------------------------------------

This document provides general guidelines about how to contribute to the project. Keep in mind these important things before you start contributing.

### Reporting issues

* Use [github issues](https://github.com/jadeep82/XLProductName/issues) to report a bug.
* Before creating a new issue:
  * Make sure you are working with the [latest release](https://github.com/jadeep82/XLProductName/releases).
  * Check if the issue was [already reported or fixed](https://github.com/jadeep82/XLProductName/issues?utf8=%E2%9C%93&q=is%3Aissue). Notice that it may not be released yet.
  * If you found a match add a brief comment "I have the same problem" or "+1". This helps prioritize the issues addressing the most common and critical first. If possible add additional information to help us reproduce and fix the issue. Please use your best judgement.    
* Reporting issues:
  * Please include the following information to help maintainers to fix the problem faster:
    * Device model.
    * iOS version you are targeting.
    * Full Xcode console output of stack trace or code compilation error.
    * Any other additional detail you think it would be useful to understand and solve the problem.


### Pull requests

* Add test coverage to the feature or fix. We only accept new feature pull requests that have related test coverage. This allows us to keep the the project stable as we move forward.
* Remember to document the new feature. We do not accept new feature pull requests without its associated documentation.
* Please only one fix or feature per pull request. This will increase the chances your feature will be merged.


###### Suggested git workflow to contribute

1. Clone your forked project into your developer machine: `git clone git@github.com:jadeep82/XLProductName.git`
2. Before starting a new feature make sure you have the latest master branch changes. `git checkout master` and then `git pull origin master`.
3. Create a new branch. Note that the starting point is the upstream master branch HEAD. `git checkout -b my-feature-name`
4. Stage all your changes `git add .` and commit them `git commit -m "Your commit message"`
5. Make sure your branch is up to date with upstream master, `git pull --rebase origin master`, resolve conflicts if necessary. This will move your commit to the top of git stack.
6. Squash your commits into one commit. `git rebase -i HEAD~6` considering you did 6 commits.
7. Push your branch into origin remote repository.
8. Create a new pull request adding any useful comment.


###### Code style and conventions

We try to follow our [swift style guide](https://github.com/jadeep82/Swift-Style-Guide).


### Feature proposal

We would love to hear your ideas and make a discussions about it.

* Use github issues to make feature proposals.
* We use `type: feature request` label to mark all [feature request issues](https://github.com/jadeep82/XLProductName/labels/type%3A%20feature%20request).
* Before submitting your proposal make sure there is no similar feature request. If you found a match feel free to join the discussion or just add a brief "+1" if you think the feature is worth implementing.
* Be as specific as possible providing a precise explanation of feature request so anyone can understand the problem and the benefits of solving it.
