class Zxcv < Formula
  desc "CLI that turns natural language into shell one-liner commands using an LLM."
  homepage "https://github.com/kuzukawa/zxcv"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kuzukawa/zxcv/releases/download/v0.1.2/zxcv-aarch64-apple-darwin.tar.xz"
      sha256 "91a684bf13d07742333c9b77ebf7af8ad4290dd7da571f36f7490948956b65e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kuzukawa/zxcv/releases/download/v0.1.2/zxcv-x86_64-apple-darwin.tar.xz"
      sha256 "f982c44365e10baf24d6a1f9b3ad440bd0e0db30add7532b9d3f0f94432af56f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kuzukawa/zxcv/releases/download/v0.1.2/zxcv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2f888f9e382ed70ef912cdfa2ceea0e52e2822e10b6a16bea6f42d9d570a5531"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kuzukawa/zxcv/releases/download/v0.1.2/zxcv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c62b83115b8e1b5b193844a0fa0487fadee8e01f3b35a3def14f7cb66cc81fa3"
    end
  end
  license "MIT"
  depends_on "fzf"

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
    bin.install "zxcv" if OS.mac? && Hardware::CPU.arm?
    bin.install "zxcv" if OS.mac? && Hardware::CPU.intel?
    bin.install "zxcv" if OS.linux? && Hardware::CPU.arm?
    bin.install "zxcv" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
