class Zxcv < Formula
  desc "CLI that turns natural language into shell one-liner commands using an LLM."
  homepage "https://github.com/kuzukawa/zxcv"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kuzukawa/zxcv/releases/download/v0.1.1/zxcv-aarch64-apple-darwin.tar.xz"
      sha256 "8e548780de2fa28dc7fe15fbdf9086f63c954f5bf691c38363f1c300a19b2f68"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kuzukawa/zxcv/releases/download/v0.1.1/zxcv-x86_64-apple-darwin.tar.xz"
      sha256 "b158a2ff4868e73392d6c33a4e53c3b9152475447653cf318f1546c1be06358e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kuzukawa/zxcv/releases/download/v0.1.1/zxcv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a53d4915e30d2c7a4c8939c8e874bee44dacc7cfb97ec261303adeee87839d25"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kuzukawa/zxcv/releases/download/v0.1.1/zxcv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9c4291e3b936019f4f178a1996967dfa74a55eb3475ca5f53fece97fa48cda4d"
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
