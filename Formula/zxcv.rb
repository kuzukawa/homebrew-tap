class Zxcv < Formula
  desc "CLI that turns natural language into shell one-liner commands using an LLM."
  homepage "https://github.com/kuzukawa/zxcv"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kuzukawa/zxcv/releases/download/v0.1.0/zxcv-aarch64-apple-darwin.tar.xz"
      sha256 "33a927c835103c44347c67126aa31462aed43f74b442ef3f051d1e442e2a974c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kuzukawa/zxcv/releases/download/v0.1.0/zxcv-x86_64-apple-darwin.tar.xz"
      sha256 "27690e6e90f7622db4a96709c2830f998fdd368ab50912e26b319f7889e7f8a5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kuzukawa/zxcv/releases/download/v0.1.0/zxcv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "554a07e19cd709e81ac1b3c4813b1d0ca47fcd950451e3584b7e26be99649cbb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kuzukawa/zxcv/releases/download/v0.1.0/zxcv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "80d53bcfdb73b4ed9b4127bd2a3704e50fec0cd336b9067f2006eea91eb7a548"
    end
  end
  license "MIT"

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
