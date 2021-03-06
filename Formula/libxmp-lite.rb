class LibxmpLite < Formula
  desc "Lite libxmp"
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.4.1/libxmp-lite-4.4.1.tar.gz"
  sha256 "bce9cbdaa19234e08e62660c19ed9a190134262066e7f8c323ea8ad2ac20dc39"

  bottle do
    cellar :any
    sha256 "d1ed5c1803f622508c3e20bb9c48f9bc644d0d639574aaa298724dd0aa17262d" => :sierra
    sha256 "a8fcd7a5ab446a221b7444b90191656175f6060a0730a703e4f862c4f49690f4" => :el_capitan
    sha256 "448d0a4bcd651c44551a1d3785de1c0181cce1ee374cd7903a629cb200a3011d" => :yosemite
  end

  # Remove for > 4.4.1
  # Fix build failure "dyld: Symbol not found: _it_loader"
  # Upstream commit "libxmp-lite building (wrong format loaders)"
  # Already in master. Original PR 6 Nov 2016 https://github.com/cmatsuoka/libxmp/pull/82
  patch :p2 do
    url "https://github.com/cmatsuoka/libxmp/commit/a028835.patch"
    sha256 "68eb66e6a8c799376f7bb2d9d96bfa8d26470ad5706d6c0cdb774d05dbbc0c15"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-'EOS'.undent
      #include <stdio.h>
      #include <libxmp-lite/xmp.h>

      int main(int argc, char* argv[]){
        printf("libxmp-lite %s/%c%u\n", XMP_VERSION, *xmp_version, xmp_vercode);
        return 0;
      }
    EOS

    system ENV.cc, "-I", include, "-L", lib, "-lxmp-lite", "test.c", "-o", "test"
    system "#{testpath}/test"
  end
end
