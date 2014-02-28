# Convenience method to retrieve a fixture
def fixture(file)
  File.read "spec/fixtures/#{file}"
end
