class CrConnector < Formula
  desc "Daemon that bridges the Remote for Claude site to claude CLI on this PC"
  homepage "https://claude-remote-platform-site.semibanbi.workers.dev"
  version "0.1.9"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/darkhtk/claude-remote-platform/releases/download/v0.1.9/cr-connector-darwin-arm64.zip"
      sha256 "2faf8e0df2c4680c6d616f24cb5814eaaddb19abb07e9ad358c5e1f240d8736e"
    end
    on_intel do
      url "https://github.com/darkhtk/claude-remote-platform/releases/download/v0.1.9/cr-connector-darwin-x64.zip"
      sha256 "dd270ae0c24d70e5638dfb42b4315b46e2f9d6a17ed73572a6008fb0a0e05dbd"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/darkhtk/claude-remote-platform/releases/download/v0.1.9/cr-connector-linux-x64.zip"
      sha256 "61e39e366537b662236e17815137c2b412984e8f90dd1b6d5c4347574af1beec"
    end
  end

  def install
    # Layout we want at install time:
    #   libexec/cr-connector              (the actual binary)
    #   libexec/behaviors/remote-claude/  (first-party free behaviors)
    #   bin/cr-connector                  (symlink → libexec/cr-connector)
    #
    # The daemon's behavior auto-discovery uses dirname(process.execPath),
    # so behaviors must sit next to the *real* binary (libexec), not next
    # to the bin shim. The symlink is enough because brew's bin/ entries
    # don't rewrite process.execPath.
    bin_files = Dir["cr-connector-*"].reject { |f| File.directory?(f) }
    odie "no cr-connector binary found in release archive" if bin_files.empty?
    libexec.install bin_files.first => "cr-connector"
    libexec.install "behaviors" if Dir.exist?("behaviors")
    bin.install_symlink libexec/"cr-connector"
  end

  test do
    assert_match "cr-connector — pair this PC", shell_output("#{bin}/cr-connector --help")
  end
end
