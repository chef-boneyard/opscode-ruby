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
