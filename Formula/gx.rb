class Gx < Formula
  desc "GX is a smart git CLI"
  homepage "https://github.com/reckerp/gx"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/reckerp/gx/releases/download/v0.2.1/gx-aarch64-apple-darwin.tar.xz"
      sha256 "e16f75198c748c67c45648c1c65ab11d8dbbe8eb562d5a02f044a4780ec86289"
    end
    if Hardware::CPU.intel?
      url "https://github.com/reckerp/gx/releases/download/v0.2.1/gx-x86_64-apple-darwin.tar.xz"
      sha256 "863321310f74af6c8d45515ad31e3772f9e68d9fce778dacca6553fdcd356650"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/reckerp/gx/releases/download/v0.2.1/gx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dbcb0c4b028dfa7e05f709768559d3177654b6feaa1ba51c2f0a18ba939d17f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/reckerp/gx/releases/download/v0.2.1/gx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "614a67200809fb882e7fa66db7825618227f8e6a1ffc017babd3e4259331acf5"
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
