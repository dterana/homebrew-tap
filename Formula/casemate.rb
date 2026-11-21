class Casemate < Formula
  desc "Future-proof file encryption CLI with versioned formats"
  homepage "https://github.com/dterana/casemate"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/dterana/casemate/releases/download/v0.8.0/casemate_0.8.0_darwin_arm64.tar.gz"
      sha256 "8d1b20ef3dcc5839c66f71ebdab2fcbaf05cb86bc79d9de888e6470a209b3b82"
    end
    on_intel do
      url "https://github.com/dterana/casemate/releases/download/v0.8.0/casemate_0.8.0_darwin_amd64.tar.gz"
      sha256 "9e634470ebdd353ddcbed3f23a59d9fba83bec614a65e702a8311b76b093366a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dterana/casemate/releases/download/v0.8.0/casemate_0.8.0_linux_arm64.tar.gz"
      sha256 "e24b21b78861bb5684c5cd1865f5eb333117514b6faf3d6cd1472a44c5e49d47"
    end
    on_intel do
      url "https://github.com/dterana/casemate/releases/download/v0.8.0/casemate_0.8.0_linux_amd64.tar.gz"
      sha256 "7fd233ceae06fea4e98e454650fc15844bd439d1ddd181c9a4ab9e4ab312eed2"
    end
  end

  def install
    bin.install "casemate"
    bash_completion.install "completions/casemate.bash" => "casemate"
    zsh_completion.install "completions/casemate.zsh" => "_casemate"
    fish_completion.install "completions/casemate.fish"
    man1.install "man/casemate.1"
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
