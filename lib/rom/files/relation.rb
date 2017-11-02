# frozen_string_literal: true

module ROM
  module Files
    class Relation < ROM::Relation
      adapter :files

      forward :select, :sort
    end
  end
end
