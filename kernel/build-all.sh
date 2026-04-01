#!/bin/bash
set -e

mkdir -p output

KMIS="android14-4.19"

mv .ddk-version .ddk-version.bak || true

for kmi in $KMIS; do
    echo "========== Building $kmi =========="
    export DDK_TARGET=$kmi
    if ddk build -e CONFIG_KSU=m; then
        if [ -f kernelsu.ko ]; then
            cp kernelsu.ko "kernelsu-${kmi}.ko"
            llvm-objcopy --strip-unneeded --discard-locals "kernelsu-${kmi}.ko"
            echo "✓ Built kernelsu-${kmi}.ko"
        fi
    else
        echo "✗ Build failed for $kmi"
    fi
    echo ""
    unset DDK_TARGET
done

mv .ddk-version.bak .ddk-version || true

echo "========== Final output =========="
ls -la
