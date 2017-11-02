shared_context 'database setup' do
  let(:configuration) { ROM::Configuration.new(:files, TMP_TEST_DIR) }
  let(:container) { ROM.container(configuration) }
end
