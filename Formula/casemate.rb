class Casemate < Formula
  desc "Future-proof file encryption CLI with versioned formats"
  homepage "https://github.com/dterana/casemate"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/dterana/casemate/releases/download/v0.4.0/casemate_0.4.0_darwin_arm64.tar.gz"
      sha256 "8cfdaaacbb140c951a6c48c4dcc06ebcb9f8e9f823fab5515cd2cf180f6406ca"
    end
    on_intel do
      url "https://github.com/dterana/casemate/releases/download/v0.4.0/casemate_0.4.0_darwin_amd64.tar.gz"
      sha256 "ed932fadc5e30899b2cf4d2dfe46b91377152bd4432a10894a5e679fa30d7a6e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dterana/casemate/releases/download/v0.4.0/casemate_0.4.0_linux_arm64.tar.gz"
      sha256 "2e98d7918ca84950a9a477555b605e733a2ec13acde6e5ed6709fd7b34352db7"
    end
    on_intel do
      url "https://github.com/dterana/casemate/releases/download/v0.4.0/casemate_0.4.0_linux_amd64.tar.gz"
      sha256 "2e6235aa1b642737e2d7183f975f0783c6726f67041cbe485770c4acaa82098e"
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
