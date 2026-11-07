cask "claude-powertools" do
  version "1.0.5"
  sha256 "0fdc2b7563dbd474795d76d5e655597d93e634279d64f64d978d13fae21ca22b"

  url "https://github.com/navneetbind/claude-powertools/archive/refs/tags/v#{version}.tar.gz"
  name "Claude PowerTools"
  desc "Browse, move and back up Claude chats, memory and MCP; manage multiple Claude instances"
  homepage "https://github.com/navneetbind/claude-powertools"

  depends_on macos: :monterey

  # One stdlib-only Python file (web UI and helper scripts are inside it).
  # A cask, not a formula: nothing is compiled, so it installs even when the
  # Mac's Xcode / Command Line Tools are older than Homebrew wants.
  binary "claude-powertools-#{version}/dist/powertools"

  # People who first installed with the old git-clone + install.sh route have a
  # copy in ~/.local/bin, which comes BEFORE brew's on PATH and would shadow every
  # upgrade. Remove it (and the old launcher app) - but only if it really is ours.
  preflight do
    system_command "/usr/bin/pkill", args: ["-f", "[/ ]powertools(\\.py)?( serve.*)?$"], must_succeed: false
    old = File.expand_path("~/.local/bin/powertools")
    if File.file?(old) && !File.symlink?(old) && File.read(old, 4096).include?("Claude PowerTools")
      File.delete(old)
      puts "Removed the old install at #{old} (brew manages powertools now)."
    end
    app = File.expand_path("~/Applications/Claude PowerTools.app")
    if File.exist?(File.join(app, "Contents", "MacOS", "powertools"))
      FileUtils.rm_rf(app)
      puts "Removed the old launcher app #{app}."
    end
  end

  caveats <<~EOS
    Start the dashboard:
      powertools open
    Claude instances, updates and fixes are under "Instances" in the dashboard.
  EOS
end
