# frozen_string_literal: true

require_relative "../../../lib/moleculer/utils/hash"

RSpec.describe Moleculer::Utils::Hash do
  let!(:obj) do
    double
  end

  let(:hash) do
    {
      "test_one"  => 1,
      "testTwo"   => 2,
      obj         => 5,
      testThree:     3,
      test_four:     4,
      child_hash:    child_hash,
    }
  end

  let(:child_hash) do
    {
      "test_one" => 1,
      "testTwo"  => 2,
      obj        => 5,
      testThree:    3,
      test_four:    4,
    }
  end

  let(:normalized_ruby_child_hash) do
    {
      test_one:   1,
      test_two:   2,
      test_three: 3,
      test_four:  4,
      obj      => 5,
    }
  end

  let(:normalized_ruby_hash) do
    {
      test_one:   1,
      test_two:   2,
      test_three: 3,
      test_four:  4,
      child_hash: normalized_ruby_child_hash,
      obj      => 5,
    }
  end

  let(:normalized_ruby_hash_from_json) do
    {
      test_one:                 1,
      test_two:                 2,
      test_three:               3,
      test_four:                4,
      child_hash:               normalized_ruby_child_hash_from_json,
      "#[_double (anonymous)]": 5,
    }
  end

  let(:normalized_ruby_child_hash_from_json) do
    {
      test_one:                 1,
      test_two:                 2,
      test_three:               3,
      test_four:                4,
      "#[_double (anonymous)]": 5,
    }
  end

  let(:camelized_child_hash) do
    {
      "testOne"   => 1,
      "testTwo"   => 2,
      "testThree" => 3,
      "testFour"  => 4,
      obj         => 5,
    }
  end

  let(:camelized_hash) do
    {
      "testOne"   => 1,
      "testTwo"   => 2,
      "testThree" => 3,
      "testFour"  => 4,
      obj         => 5,
      "childHash" => camelized_child_hash,
    }
  end

  let(:json) do
    "{\"testOne\":1,\"testTwo\":2,\"#[Double (anonymous)]\":5,\"testThree\":3,\"testFour\":4,\"childHash\":" \
      "{\"testOne\":1,\"testTwo\":2,\"#[Double (anonymous)]\":5,\"testThree\":3,\"testFour\":4}}"
  end

  describe "::to_json" do
    it "converts the hash to json" do
      expect(described_class.to_json(hash)).to eq(json)
    end
  end

  describe "#from_json" do
    it "converts the provided json to a hash" do
      expect(described_class.from_json(json)).to include(normalized_ruby_hash_from_json)
    end
  end

  describe "#camelize_hash" do
    it "camelizes the values in the hash" do
      expect(described_class.camelize_hash(hash)).to include(camelized_hash)
    end
  end

  describe "#symbolize" do
    it "returns a new has with the keys symbolized" do
      expect(described_class.symbolize(hash)).to include(normalized_ruby_hash)
    end
  end
end
