# frozen_string_literal: true

require 'rom/files/extensions/gem/types'

RSpec.describe ROM::Files::Types::Gem::Name do
  its(['dry-types']) { is_expected.to eq 'dry-types' }
end

RSpec.describe ROM::Files::Types::Gem::Version do
  its(['0.0.0']) { is_expected.to eq Gem::Version.create('0.0.0') }
end

RSpec.describe ROM::Files::Types::Gem::Requirement do
  its(['0.0.0']) { is_expected.to eq Gem::Requirement.create('0.0.0') }
  its(['>= 0.0.0']) { is_expected.to eq Gem::Requirement.create('>= 0.0.0') }
  its(['~> 0.0.0']) { is_expected.to eq Gem::Requirement.create('~> 0.0.0') }
end

RSpec.describe ROM::Files::Types::Gem::Requirements do
  its([['0.0.0']]) { is_expected.to eq [Gem::Requirement.create('0.0.0')] }
  its(['0.0.0']) { is_expected.to eq [Gem::Requirement.create('0.0.0')] }
end

RSpec.describe ROM::Files::Types::Gem::Dependency do
  its(['dry-system']) { is_expected.to eq ['dry-system'] }
  its(['dry-system ~> 0.8']) { is_expected.to eq ['dry-system', Gem::Requirement.create('~> 0.8')] }
  its(['dry-system ~> 0.8, >= 0.8.5']) { is_expected.to eq ['dry-system', Gem::Requirement.create('~> 0.8'), Gem::Requirement.create('>= 0.8.5')] }
end
