class Gx < Formula
  desc "GX is a smart git CLI"
  homepage "https://github.com/reckerp/gx"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/reckerp/gx/releases/download/v0.3.0/gx-aarch64-apple-darwin.tar.xz"
      sha256 "7e35a195d0c76030ab932c34c182c93d13e0177772d7b0322861739d36d7c9e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/reckerp/gx/releases/download/v0.3.0/gx-x86_64-apple-darwin.tar.xz"
      sha256 "970e5a834b49c73bc9df55a901dabad5880cfe91609481adfc09d5105678c412"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/reckerp/gx/releases/download/v0.3.0/gx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dac33cb775b92c1b200fb225c927ca8ab51f79d5588faf4c2019f05fde27a40c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/reckerp/gx/releases/download/v0.3.0/gx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a34ca751406c70749f855a99e8005a5304acd136fc64aea7f328f90a7470475b"
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
