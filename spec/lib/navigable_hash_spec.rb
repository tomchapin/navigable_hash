require 'spec_helper'
require 'pry'
require 'helpers/helper_methods'

RSpec.configure do |c|
  c.extend NavigableHash::HelperMethods
end

describe NavigableHash do

  TEST_HASH = { symbol_key: 'symbol_key_value', 'string_key' => 'string_key_value', hash_item: { inner_value: true }, array: [ {}, 'string', :symbol ] , nil_value: nil, object: Object.new }

  let(:hash){ TEST_HASH }
  let(:navigable){ NavigableHash.new(hash) }

  describe "#[]" do

    context "given a hash" do
      it "should return a new instance of navigable hash" do
        navigable[:hash_item].should be_a NavigableHash
      end
    end

    context "given an array" do
      it "should call #navigate with each value" do
        navigable.should_receive(:navigate_array).with(hash[:array])
        navigable[:array]
      end
    end

    context "given any object" do
      it "should return a value" do
        navigable.should_receive(:navigate_value).with(hash[:object]).any_number_of_times.and_call_original
        navigable[:object].should == hash[:object]
      end
    end

    context "given nil" do
      it "should return a value" do
        navigable.should_receive(:navigate_value).with(hash[:nil_value]).any_number_of_times.and_call_original
        navigable[:nil_value].should == hash[:nil_value]
        navigable[:nil_value].should be_nil
      end
    end

  end

  describe "#==" do
    it "should be equal to a hash" do
      navigable.should == hash
    end
  end

  context "with dot notation" do
    TEST_HASH.keys.each do |key_name|
      test_key_with_dot_notation(key_name, TEST_HASH)
    end
  end

  context "with symbol notation" do
    TEST_HASH.keys.each do |key_name|
      test_key_with_symbol_notation(key_name, TEST_HASH)
    end
  end

  context "with string notation" do
    TEST_HASH.keys.each do |key_name|
      test_key_with_string_notation(key_name, TEST_HASH)
    end
  end

  describe "#respond_to?" do
    it "should always be true" do
      navigable.respond_to?(:this_is_not_a_method).should be_true
    end
  end

  describe "#method_missing" do
    it "should return nil" do
      navigable.this_is_not_a_method.should be_nil
    end

    it "should not raise an error" do
      expect { navigable.this_is_not_a_method }.to_not raise_error
    end
  end

end