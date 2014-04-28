@test "installs the correct version of Ruby" {
  ruby --version | grep 1.9.3p484
}

@test "installs a requested global gems into the correct Ruby" {
  # We have unset these vars to bust out of Busser's sandbox
  unset GEM_HOME GEM_PATH GEM_CACHE
  run gem list bundler -i
  [ "$status" -eq 0 ]
  run gem list mixlib-shellout -i
  [ "$status" -eq 0 ]
}

@test "creates the rbenv user with a specific UID" {
  [ "x393" == "x`getent passwd rbenv | awk -F: '{print $3}'`" ]
}

@test "creates the rbenv group with the same UID as the user" {
  [ "x393" == "x`getent group rbenv | awk -F: '{print $3}'`" ]
}