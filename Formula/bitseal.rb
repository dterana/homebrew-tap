class Bitseal < Formula
  desc "Future-proof file encryption CLI with versioned formats"
  homepage "https://github.com/dterana/bitseal"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/dterana/bitseal/releases/download/v0.3.0/bitseal_0.3.0_darwin_arm64.tar.gz"
      sha256 "1c4f36effeb013cd9bfc19356f1f1906bd91e603493b4d8218e4a47718163d94"
    end
    on_intel do
      url "https://github.com/dterana/bitseal/releases/download/v0.3.0/bitseal_0.3.0_darwin_amd64.tar.gz"
      sha256 "8b6839ea42f1f20c41dbd254cb95a43fee5037e7edc73404488937978f7dc399"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dterana/bitseal/releases/download/v0.3.0/bitseal_0.3.0_linux_arm64.tar.gz"
      sha256 "abc16ee1a567c859effd9f51124e011eec27de9b75c5ae752751c2664e159ead"
    end
    on_intel do
      url "https://github.com/dterana/bitseal/releases/download/v0.3.0/bitseal_0.3.0_linux_amd64.tar.gz"
      sha256 "c3d98d55183f752842b31ae2d058bdfb92c20283c7fb876189b8173c98f990bf"
    end
  end

  def install
    bin.install "bitseal"
  end

  test do
    assert_match "Bitseal v#{version}", shell_output("#{bin}/bitseal version")

    # round trip with the password taken from the environment
    ENV["BITSEAL_TEST_PASSWORD"] = "correct horse battery staple"
    (testpath/"note.txt").write("hello from the formula test")
    system bin/"bitseal", "encrypt", "-password-env", "BITSEAL_TEST_PASSWORD", "note.txt"
    rm testpath/"note.txt"
    system bin/"bitseal", "decrypt", "-password-env", "BITSEAL_TEST_PASSWORD", "note.txt.enc"
    assert_equal "hello from the formula test", (testpath/"note.txt").read
  end
end
