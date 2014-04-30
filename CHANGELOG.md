opscode-ruby Cookbook CHANGELOG
===============================
This file is used to list changes made in each version of the
opscode-ruby cookbook.

v1.3.0
------
### Improvement
- Add Ubuntu 14.04 to `.kitchen.yml`

### New Feature
- Add rbenv UID attribute
- Set rbenv user/group to UID/GID per attribute

v1.2.1
-------
### Improvement
- Add CentOS to `.kitchen.yml`.

### Bug
- Add a workaround for [CHEF-3940]

v1.2.0
-------
### Improvement
- Change default Ruby to 1.9.3-p484 (addresses [CVE-2013-4164])
- Refactor recipe to install Ruby on Windows
- Update `.kitchen.yml` for final 1.0 format.
- Add BATS integration tests.
- Add Foodcritic support.
- Add Rubocop support.

### Bug
- Ensure cookbook relies on 7-zip (needed for Windows install).

v1.1.0
-------
### Improvement
- Bump rbenv cookbook to 1.6.5
- Bump default Ruby to 1.9.3p448 (latest stable in 1.9 series)

v1.0.0
-------
### Improvement
- Make `ruby_versions`, global ruby version and base gems configurable.

### Feature
- Ability to install ruby on windows. Single version installation only.

v0.1.1
-------
### Feature
- The initial release.
