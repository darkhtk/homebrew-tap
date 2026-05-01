class CrConnector < Formula
  desc "Daemon that bridges the Remote for Claude site to claude CLI on this PC"
  homepage "https://claude-remote-platform-site.semibanbi.workers.dev"
  version "0.1.8"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/darkhtk/claude-remote-platform/releases/download/v0.1.8/cr-connector-darwin-arm64.zip"
      sha256 "7a7dc3150d04178c8d057698c9159140f1a16ca28e9385718ed0930d44924511"
    end
    on_intel do
      url "https://github.com/darkhtk/claude-remote-platform/releases/download/v0.1.8/cr-connector-darwin-x64.zip"
      sha256 "c828c4ad0b683fc2b0cb00db12a49df2124ea727e0804a2e8a4d3c05bcc33689"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/darkhtk/claude-remote-platform/releases/download/v0.1.8/cr-connector-linux-x64.zip"
      sha256 "f7393dbbe2cdb6c3578f797c77feafc62d7e04f04f1ef15d4454db05ef8b927c"
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
