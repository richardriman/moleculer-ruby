# frozen_string_literal: true

RSpec.describe Moleculer::Support::Hash do
  subject { Moleculer::Support::Hash }
  let!(:obj) do
    double
  end

  let!(:child_hash) do
    {
      "test_one" => 1,
      "testTwo" => 2,
      testThree: 3,
      test_four: 4,
      obj => 5,
    }
  end

  let(:hash) do
    {
      "test_one" => 1,
      "testTwo" => 2,
      testThree: 3,
      test_four: 4,
      obj => 5,
      child_hash: child_hash,
    }
  end

  describe "::symbolize" do
    it "returns a new has with the keys symbolized" do
      expect(subject.symbolize(hash)).to include(
        test_one: 1,
        testTwo: 2,
        testThree: 3,
        test_four: 4,
        obj => 5,
        child_hash: child_hash,
      )
    end
  end

  describe "deep_symbolize" do
    it "returns a new has with the keys symbolized" do
      expect(subject.deep_symbolize(hash)).to include(
        test_one: 1,
        testTwo: 2,
        testThree: 3,
        test_four: 4,
        obj => 5,
        child_hash: {
          test_one: 1,
          testTwo: 2,
          testThree: 3,
          test_four: 4,
          obj => 5,
        },
      )
    end
  end

  describe "::fetch" do
    it "fetches correctly" do
      expect(subject.fetch(hash, :testOne)).to eq 1
      expect(subject.fetch(hash, :test_two)).to eq 2
      expect(subject.fetch(hash, "test_three")).to eq 3
      expect(subject.fetch(hash, "testFour")).to eq 4
      expect(subject.fetch(hash, obj)).to eq 5
      expect(subject.fetch(hash, :not_there, "foo")).to eq "foo"
    end
  end
end
