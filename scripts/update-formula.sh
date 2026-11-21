#!/usr/bin/env bash
# Regenerates Formula/casemate.rb from a casemate release (the latest one, pre-releases
# included, unless a tag is given). Prints the tag it used as the last line of stdout.
set -euo pipefail

repo="dterana/casemate"
tag="${1:-$(gh api "repos/$repo/releases?per_page=1" --jq '.[0].tag_name')}"
ver="${tag#v}"

sums="$(gh release download "$tag" --repo "$repo" --pattern checksums.txt --output -)"
sha() { awk -v f="casemate_${ver}_$1.tar.gz" '$2 == f { print $1 }' <<<"$sums"; }

for target in darwin_arm64 darwin_amd64 linux_arm64 linux_amd64; do
  [ -n "$(sha "$target")" ] || { echo "no checksum for $target in $tag" >&2; exit 1; }
done

base="https://github.com/$repo/releases/download/$tag/casemate_${ver}"
cat > "$(dirname "$0")/../Formula/casemate.rb" <<EOF
class Casemate < Formula
  desc "Future-proof file encryption CLI with versioned formats"
  homepage "https://github.com/$repo"
  license "MIT"

  on_macos do
    on_arm do
      url "${base}_darwin_arm64.tar.gz"
      sha256 "$(sha darwin_arm64)"
    end
    on_intel do
      url "${base}_darwin_amd64.tar.gz"
      sha256 "$(sha darwin_amd64)"
    end
  end

  on_linux do
    on_arm do
      url "${base}_linux_arm64.tar.gz"
      sha256 "$(sha linux_arm64)"
    end
    on_intel do
      url "${base}_linux_amd64.tar.gz"
      sha256 "$(sha linux_amd64)"
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
EOF

echo "formula written for $tag" >&2
echo "$tag"
