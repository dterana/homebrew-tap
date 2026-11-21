class Casemate < Formula
  desc "Future-proof file encryption CLI with versioned formats"
  homepage "https://github.com/dterana/casemate"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/dterana/casemate/releases/download/v0.7.0/casemate_0.7.0_darwin_arm64.tar.gz"
      sha256 "f4f4eba36182b8145d3dfc07a4eac2a28bd39f9a91cd753b3fcaaa5e22211089"
    end
    on_intel do
      url "https://github.com/dterana/casemate/releases/download/v0.7.0/casemate_0.7.0_darwin_amd64.tar.gz"
      sha256 "1e3f7622ec4205430af92022a13d6de906849443cbeeb48d18d43f88da4c2648"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dterana/casemate/releases/download/v0.7.0/casemate_0.7.0_linux_arm64.tar.gz"
      sha256 "fa629452e3f3ccc73e8dbc7b22d3836ad91bf93b23fbd64171c717506fee0d1c"
    end
    on_intel do
      url "https://github.com/dterana/casemate/releases/download/v0.7.0/casemate_0.7.0_linux_amd64.tar.gz"
      sha256 "c0e423ece326853127683a2440759b60058067b9900b94959c0e86529902f20e"
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
