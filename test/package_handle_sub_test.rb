require 'helper'

class HandlePackageSubTest < Rip::Test
  test "can't handle base paths" do
    out = rip "package-handle-sub git://localhost/rails"
    assert_exited_with_error out

    out = rip "package-handle-sub git://localhost/rails /"
    assert_exited_with_error out
  end

  test "fetch git:// package with path" do
    out = rip "package-handle-sub git://localhost/rails /activerecord"
    target = "#{@ripdir}/.packages/rails-activerecord-06e3a14fe30bceac347f56b5e2a4d398"

    assert_equal target, out.chomp
    assert File.directory?(target)
    assert File.exist?("#{target}/lib/active_record.rb")
  end

  test "fetch git:// package with nonexistent path" do
    out = rip "package-handle-sub git://localhost/rails /merb"
    assert_equal "git://localhost/rails /merb does not exist", out.chomp
  end

  test "writes metadata.rip" do
    out = rip "package-handle-sub git://localhost/rails /activerecord"
    target = "#{@ripdir}/.packages/rails-activerecord-06e3a14fe30bceac347f56b5e2a4d398"

    assert_equal target, out.chomp
    assert File.exist?("#{target}/metadata.rip")
    assert_equal "git://localhost/rails /activerecord dcdc6458e123fd5e412832fd729500e20ce542be\n",
      File.read("#{target}/metadata.rip")
  end

  test "writes .ripparent symlink" do
    out = rip "package-handle-sub git://localhost/rails /activerecord"
    target = "#{@ripdir}/.packages/rails-activerecord-06e3a14fe30bceac347f56b5e2a4d398"

    assert_equal target, out.chomp
    assert File.symlink?("#{target}/.ripparent")
    assert_equal "#{@ripdir}/.packages/rails-ed4cb2c29c01dd09ac6ee2a4b1faa3e1",
      File.readlink("#{target}/.ripparent")
  end

  test "reload" do
    out = rip "package-handle-sub git://localhost/rails /activerecord"
    target = "#{@ripdir}/.packages/rails-activerecord-06e3a14fe30bceac347f56b5e2a4d398"

    assert_equal target, out.chomp
    assert File.directory?(target)

    out = rip "package-reload #{target}"

    assert_equal target, out.chomp
    assert File.directory?(target)
  end
end
