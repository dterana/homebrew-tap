#!/usr/bin/env bash
# Regenerates Formula/bitseal.rb from a bitseal release (the latest one, pre-releases
# included, unless a tag is given). Prints the tag it used as the last line of stdout.
set -euo pipefail

repo="dterana/bitseal"
tag="${1:-$(gh api "repos/$repo/releases?per_page=1" --jq '.[0].tag_name')}"
ver="${tag#v}"

sums="$(gh release download "$tag" --repo "$repo" --pattern checksums.txt --output -)"
sha() { awk -v f="bitseal_${ver}_$1.tar.gz" '$2 == f { print $1 }' <<<"$sums"; }

for target in darwin_arm64 darwin_amd64 linux_arm64 linux_amd64; do
  [ -n "$(sha "$target")" ] || { echo "no checksum for $target in $tag" >&2; exit 1; }
done

base="https://github.com/$repo/releases/download/$tag/bitseal_${ver}"
cat > "$(dirname "$0")/../Formula/bitseal.rb" <<EOF
class Bitseal < Formula
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
EOF

echo "formula written for $tag" >&2
echo "$tag"
