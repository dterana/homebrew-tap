class Bitseal < Formula
  desc "Future-proof file encryption CLI with versioned formats"
  homepage "https://github.com/dterana/bitseal"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/dterana/bitseal/releases/download/v0.3.1/bitseal_0.3.1_darwin_arm64.tar.gz"
      sha256 "c735bd906e3b6ea5ac1271897839c6e2f5da5d0be5227c6e7e7280e4c1c295a8"
    end
    on_intel do
      url "https://github.com/dterana/bitseal/releases/download/v0.3.1/bitseal_0.3.1_darwin_amd64.tar.gz"
      sha256 "505cb75d6b4b478dc6287682a8a8602ffd250bbfaa6105df098c29cd54fa2da8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dterana/bitseal/releases/download/v0.3.1/bitseal_0.3.1_linux_arm64.tar.gz"
      sha256 "6ba559f9010e28d28e415eeee6de0c86af579203f1ef02c537159e9be97b681e"
    end
    on_intel do
      url "https://github.com/dterana/bitseal/releases/download/v0.3.1/bitseal_0.3.1_linux_amd64.tar.gz"
      sha256 "c5248240377ca55af546254354622f57cddc416838ed5e7791085d24d9954ea3"
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
