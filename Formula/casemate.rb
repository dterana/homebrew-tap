class Casemate < Formula
  desc "Future-proof file encryption CLI with versioned formats"
  homepage "https://github.com/dterana/casemate"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/dterana/casemate/releases/download/v0.6.0/casemate_0.6.0_darwin_arm64.tar.gz"
      sha256 "af3cd00b67ee9f0eb3d72321597060397e6cffb973943a6ff68744de62a54345"
    end
    on_intel do
      url "https://github.com/dterana/casemate/releases/download/v0.6.0/casemate_0.6.0_darwin_amd64.tar.gz"
      sha256 "ac182a78c42e9eb1e299d5144f402071912f7a50cf5a8972e27494368bad9229"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dterana/casemate/releases/download/v0.6.0/casemate_0.6.0_linux_arm64.tar.gz"
      sha256 "004b63e2401abf350fc4d3e3d73a48dc4c63d673f8d2e42879c8d5d8bcaeba18"
    end
    on_intel do
      url "https://github.com/dterana/casemate/releases/download/v0.6.0/casemate_0.6.0_linux_amd64.tar.gz"
      sha256 "00fe1773cb14fc58e507b6e5cb8a37b6a421fcaf331f69a26d6eb181954be0d5"
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
