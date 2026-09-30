cask "claude-powertools" do
  version "1.0.1"
  sha256 "f0804edfa77a0976ddd4fca90c851b1071aea524eb391532bd0850e9a24cb74b"

  url "https://github.com/navneetbind/claude-powertools/archive/refs/tags/v#{version}.tar.gz"
  name "Claude PowerTools"
  desc "Browse, move and back up Claude chats, memory and MCP; manage multiple Claude instances"
  homepage "https://github.com/navneetbind/claude-powertools"

  depends_on macos: :monterey

  # One stdlib-only Python file (web UI and helper scripts are inside it).
  # A cask, not a formula: nothing is compiled, so it installs even when the
  # Mac's Xcode / Command Line Tools are older than Homebrew wants.
  binary "claude-powertools-#{version}/dist/powertools"

  caveats <<~EOS
    Start the dashboard:
      powertools open
    Claude instances, updates and fixes are under "Instances" in the dashboard.
  EOS
end
