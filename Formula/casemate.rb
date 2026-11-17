class Casemate < Formula
  desc "Future-proof file encryption CLI with versioned formats"
  homepage "https://github.com/dterana/casemate"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/dterana/casemate/releases/download/v0.6.1/casemate_0.6.1_darwin_arm64.tar.gz"
      sha256 "202602fec4d615070116124897506054ac94600b86b8ea0ba9ab3fbdb1f59f94"
    end
    on_intel do
      url "https://github.com/dterana/casemate/releases/download/v0.6.1/casemate_0.6.1_darwin_amd64.tar.gz"
      sha256 "7283621ead593b024f7f668c5673734b5d376751d73d78ee5187748e0855f228"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dterana/casemate/releases/download/v0.6.1/casemate_0.6.1_linux_arm64.tar.gz"
      sha256 "33dfe4afb8236caf1d9727f89a6a35ad5150460a43f3a34bc898c336dd64f46d"
    end
    on_intel do
      url "https://github.com/dterana/casemate/releases/download/v0.6.1/casemate_0.6.1_linux_amd64.tar.gz"
      sha256 "0af50af4abca60c5028a6ac09c099e557001c4634d56b4bd4e822601dcc57c62"
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
