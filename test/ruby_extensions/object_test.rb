require File.dirname(__FILE__) + '/../test_helper'

class ObjectTest < Test::Unit::TestCase

  context "an extended Object" do
    setup do
      @obj = Object.new
      @true = true
      @false = false
    end
    subject { @obj }

    should_have_instance_methods 'false?', 'is_false?', 'true?', 'is_true?'

    should "know if its true" do
      assert @true.true?
      assert @true.is_true?
      assert !@false.true?
      assert !@false.is_true?
    end
    should "know if its false" do
      assert !@true.false?
      assert !@true.is_false?
      assert @false.false?
      assert @false.is_false?
    end

    should_have_instance_methods 'capture_std_output'
    should "capture $stdout" do
      out, err = capture_std_output do
        p "some output"
      end
      assert_kind_of ::StringIO, out
      assert_kind_of ::StringIO, err
      assert err.string.empty?
      assert_equal "\"some output\"\n", out.string
    end
    should "capture $stderr" do
      out, err = capture_std_output do
        $stderr.write "an error"
      end
      assert out.string.empty?
      assert_equal "an error", err.string
    end
    should "capture both $stdout and $stderr at the same time" do
      out, err = capture_std_output do
        p "some more output"
        $stderr.write "an error"
      end
      assert_equal "\"some more output\"\n", out.string
      assert_equal "an error", err.string
    end

    should_have_instance_methods 'blank?', 'try'

    should "know if it is blank" do
      [nil, false,"",[],{}].each do |obj|
        assert obj.blank?
      end
      [true, "poo", [1], {:one => 1}].each do |obj|
        assert !obj.blank?
      end
    end

    should "try method calls with nil safety" do
      obj = [1,2,3]
      nested_obj = [['a','b','c'], 1, 2, 3, nil]
      assert_equal obj.first, obj.try(:first)
      assert_equal nested_obj.first.first, nested_obj.try(:first).try(:first)
      assert_equal nil, nested_obj.try(:last).try(:first)
    end

    should "execute commands with sudo" do
      sudo("echo \"sudo cmd\"") do |status, result|
        assert_equal 0, status.to_i, "sudo didn't return status number correctly"
        assert_equal "0", status.to_s, "sudo didn't return status string correctly"
        assert_equal "sudo cmd\n", result, "sudo didn't return the right result"
      end

      sudo("cd ~") do |status, result|
        assert_equal 0, status.to_i, "sudo didn't return status number correctly"
        assert_equal "0", status.to_s, "sudo didn't return status string correctly"
        assert_equal nil, result, "sudo didn't return the right success result"
      end

      assert_equal 0, sudo("cd ~").to_i, "sudo w/ no block should return successfully"

      sudo("cd ~/asdgasdgsdgsdgsadasdhasdh") do |status, result|
        assert status.to_i != 0, "sudo didn't return an error status"
        assert result =~ /No such file or directory/, "sudo didn't return the right error result"
      end
    end

  end

end