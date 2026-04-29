class CrConnector < Formula
  desc "Daemon that bridges the Remote for Claude site to claude CLI on this PC"
  homepage "https://claude-remote-platform-site.semibanbi.workers.dev"
  version "0.1.0"
  license "AGPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/darkhtk/claude-remote-platform/releases/download/v0.1.0/cr-connector-darwin-arm64.zip"
      sha256 "d78e738bf822d902dca9fb5915000da5e72e2e77539823a78f6467d539a9a281"
    end
    on_intel do
      url "https://github.com/darkhtk/claude-remote-platform/releases/download/v0.1.0/cr-connector-darwin-x64.zip"
      sha256 "ca1802311563b8d8f32609f9be807098e8b02c57bea1aee3bc79b2bb3de28a64"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/darkhtk/claude-remote-platform/releases/download/v0.1.0/cr-connector-linux-x64.zip"
      sha256 "ed27761bb5930f4100987666b1bcd39d66be1354b25cbf7947f0da0120078f9b"
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
