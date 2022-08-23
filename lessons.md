# Lessons learned

## Github workflow fun

Working on your own is quite straightforward and well-documented.  If you are contributing on a forked repository though things are a little more insteresting:

First you need to enable actions on your fork as they are disabled by default on forks (as are issues ...)

Then it is a little unclear and confusing, but seems to be the case that:

- Your workflow yaml _MUST_ exists in the default/_main_ branch for github to use it at all
- If it is running on/against a branch, then it will use the version on the branch (so must exist there as well)
- If your "fork" workflows are not to be added to/contributed upstream (and there are more reasons NOT to want or allow this than to want to), well you'll probably need to keep a seperate re-based upstream branch tracking upstream/main from which to branch your contributions and which will have to be kept unpoluted by merges from your own testing and local workflow-enabled branches

