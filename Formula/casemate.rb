class Casemate < Formula
  desc "Future-proof file encryption CLI with versioned formats"
  homepage "https://github.com/dterana/casemate"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/dterana/casemate/releases/download/v0.5.0/casemate_0.5.0_darwin_arm64.tar.gz"
      sha256 "f1aa4d658996a5b0aa62cab0158e71e6aba9a018fcae9dbe917573ec907d78a1"
    end
    on_intel do
      url "https://github.com/dterana/casemate/releases/download/v0.5.0/casemate_0.5.0_darwin_amd64.tar.gz"
      sha256 "66ee0381ae741e01bea44762bd2e30ef9941acdc5d96e9b9daffe17e98763806"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dterana/casemate/releases/download/v0.5.0/casemate_0.5.0_linux_arm64.tar.gz"
      sha256 "d7554f7f0ef5b08bddcbcdc9a1f5541cdea8b4ed8569e3457a411edaf05edd74"
    end
    on_intel do
      url "https://github.com/dterana/casemate/releases/download/v0.5.0/casemate_0.5.0_linux_amd64.tar.gz"
      sha256 "c50868d10ae6c0bf2f0cabed7e4c67bd19734b8516b137d24566697fde8d7968"
    end
  end

  def install
    bin.install "casemate"
  end

  test do
    assert_match "Casemate v#{version}", shell_output("#{bin}/casemate version")

    # round trip with the password taken from the environment
    ENV["CASEMATE_TEST_PASSWORD"] = "correct horse battery staple"
    (testpath/"note.txt").write("hello from the formula test")
    system bin/"casemate", "encrypt", "-password-env", "CASEMATE_TEST_PASSWORD", "note.txt"
    rm testpath/"note.txt"
    system bin/"casemate", "decrypt", "-password-env", "CASEMATE_TEST_PASSWORD", "note.txt.enc"
    assert_equal "hello from the formula test", (testpath/"note.txt").read
  end
end
