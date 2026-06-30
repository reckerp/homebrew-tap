class Gx < Formula
  desc "GX is a smart git CLI"
  homepage "https://github.com/reckerp/gx"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/reckerp/gx/releases/download/v0.4.0/gx-aarch64-apple-darwin.tar.xz"
      sha256 "669075439ca29b57a6c1209114667ad3d1e2609534a9606e2abc5fbd6277d562"
    end
    if Hardware::CPU.intel?
      url "https://github.com/reckerp/gx/releases/download/v0.4.0/gx-x86_64-apple-darwin.tar.xz"
      sha256 "5fb81d61aa00cadc4e3e007ddff83a7e1ae4d266ce36ad606ef2eeef0c24db06"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/reckerp/gx/releases/download/v0.4.0/gx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "38c3fe035d7bce867695cddd1a6171e8699e568510c56f799d8394135c7136df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/reckerp/gx/releases/download/v0.4.0/gx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8db76525140fb8e3d69cc7b1fa2ef8e30ea9956c106d59bfad3a1dc5762e14ea"
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
