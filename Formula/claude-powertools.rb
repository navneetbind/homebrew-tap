class ClaudePowertools < Formula
  desc "Browse, move and back up Claude chats, memory and MCP; manage multiple Claude app instances"
  homepage "https://github.com/navneetbind/claude-powertools"
  url "https://github.com/navneetbind/claude-powertools/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "f0804edfa77a0976ddd4fca90c851b1071aea524eb391532bd0850e9a24cb74b"
  license :cannot_represent
  depends_on :macos

  def install
    # One stdlib-only Python file; the update/instance scripts and the web UI
    # are carried inside it.
    bin.install "dist/powertools"
  end

  def caveats
    <<~EOS
      Start the dashboard:
        powertools open

      Claude instances, updates and fixes live under "Instances" in the dashboard.
      Everything is local: it binds to 127.0.0.1 and never sends your chats anywhere.
    EOS
  end

  test do
    assert_match "usage: powertools", shell_output("#{bin}/powertools --help")
  end
end
