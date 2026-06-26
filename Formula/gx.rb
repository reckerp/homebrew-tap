class Gx < Formula
  desc "GX is a smart git CLI"
  homepage "https://github.com/reckerp/gx"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/reckerp/gx/releases/download/v0.2.5/gx-aarch64-apple-darwin.tar.xz"
      sha256 "52d6293ac424d0102c73f658aba7a6f7d8eb538ab9385abe3c0d81cbfac49d85"
    end
    if Hardware::CPU.intel?
      url "https://github.com/reckerp/gx/releases/download/v0.2.5/gx-x86_64-apple-darwin.tar.xz"
      sha256 "e8485b1f0e7b8be03b67cf65f0fe3a95c79e172def1b7321f8f05b180a5d13db"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/reckerp/gx/releases/download/v0.2.5/gx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c51dd54035b9832e06c73597ca7eaf45d6e893db3e6ae2dcd08c2887898f46c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/reckerp/gx/releases/download/v0.2.5/gx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a4ef9b6d452050608d79986e5a9437ec1598b29909656d4d2d0fe19a6425f47e"
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
