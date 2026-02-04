class Gx < Formula
  desc "GX is a smart git CLI"
  homepage "https://github.com/reckerp/gx"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/reckerp/gx/releases/download/v0.1.3/gx-aarch64-apple-darwin.tar.xz"
      sha256 "c443ef2911f745d194ae79f08ca4556f24388c11904f327034959d95f30f80ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/reckerp/gx/releases/download/v0.1.3/gx-x86_64-apple-darwin.tar.xz"
      sha256 "835f713f8caebc40514a8a95c6233071642fa51736f5c019f18497b02238e4ce"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/reckerp/gx/releases/download/v0.1.3/gx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c83a2e5de31c6190e3e296645a271a29e721a663d36c2e2edcc3b20c313f06ac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/reckerp/gx/releases/download/v0.1.3/gx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cb51897e99951fe0614f162a5c5db01ef3afc383992ca212840781857b0e15dd"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "gx" if OS.mac? && Hardware::CPU.arm?
    bin.install "gx" if OS.mac? && Hardware::CPU.intel?
    bin.install "gx" if OS.linux? && Hardware::CPU.arm?
    bin.install "gx" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
