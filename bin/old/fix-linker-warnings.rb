#!ruby

#
# This ruby program will patch the linker executable (link.exe)
# so that linker warning LNK4099 is ignorable.
#
# NOTE: This program must be run in an elevated (UAC) command-prompt
# since it writes files that are only writable by Administrator.
#
# http://bitsquid.blogspot.com/2011/12/code-share-patch-linkexe-to-ignore.html

require "fileutils"

def link_exes()
  res = []
  [ "VS90COMNTOOLS", "VS100COMNTOOLS", "VS110COMNTOOLS", "VS120COMNTOOLS" ].each do |var|
    next if ENV[var].nil?
    res << File.join(ENV[var], "../../VC/bin/link.exe")
    res << File.join(ENV[var], "../../VC/bin/x86_amd64/link.exe")
  end

  xedk = ENV["XEDK"] || 'c:\Program Files (x86)\Microsoft Durango XDK\xdk\VC'
  res << File.join(xedk, "bin/win32/link.exe")
  res << File.join(xedk, "bin/amd64/link.exe")
  res << File.join(xedk, "bin/x86_amd64/link.exe")

  return res
end

def patch_link_exe(exe)
  data = nil
  File.open(exe, "rb") {|f| data = f.read}
  unpatched = [4088, 4099, 4105].pack("III")
  patched   = [4088, 65535, 4105].pack("III")

  if data.scan(patched).size > 0
    puts "* Already patched #{exe}"
    return
  end

  num_unpatched = data.scan(unpatched).size
  if num_unpatched > 1
    $stderr.puts "Multiple patch locations in #{exe}"
    return
  end
  if num_unpatched == 0
    $stderr.puts "Patch location not found in #{exe}"
    return
  end

  offset = data.index(unpatched)
  puts "* Found patch location #{exe}:#{offset}"
  bak = exe + "-" + Time.now.strftime("%y%m%d-%H%M%S") + ".bak"
  puts "  Creating backup #{bak}"
  FileUtils.cp(exe, bak)
  puts "  Patching exe"
  data[offset,unpatched.size] = patched
  File.open(exe, "wb") {|f| f.write(data)}
end

link_exes.each do |exe|
  if File.exists?(exe)
    patch_link_exe(exe)
  else
    puts "* Missing #{exe}"
  end
end
