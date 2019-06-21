#!/bin/bash -eux

curl -L 'https://ci.centos.org/artifacts/fedora-coreos/prod/builds/latest/meta.json' | \
  jq '
{
  "artifact_baseurl": "https://ci.centos.org/artifacts/fedora-coreos/prod/builds/",
  "iso_name": .images.iso.path, 
  "iso_checksum": .images.iso.sha256,
  "iso_checksum_type": "sha256",
  "artifact_version": .buildid,
  "metal_name": .["images"]["metal-bios"]["path"],
  "metal_checksum": .["images"]["metal-bios"]["sha256"]
}' | tee vars.json

eval "BASEURL='''$(jq -r '.artifact_baseurl' < vars.json)'''"
eval "BUILDID='''$(jq -r '.artifact_version' < vars.json)'''"
eval "IMG_SHA"='''$(jq -r '.metal_checksum' < vars.json)'''"
eval "IMG_NAME"='''$(jq -r '.metal_name' < vars.json)'''"

mkdir -p http; cd http

OK=-1
if [ -f "${IMG_NAME}" ]
then
    echo "Verifying existing image"
    echo "${IMG_SHA}  ${IMG_NAME}" | shasum -c -
    OK=$?
fi

if [ "${OK}" -eq "0" ]
then
    echo "Existing image verified. Skipping download."
else
    echo "Download and verify new image"
    curl -sL -o "${IMG_NAME}" "${BASEURL}/${BUILDID}/${IMG_NAME}"
    echo "${IMG_SHA}  ${IMG_NAME}" | shasum -c -
fi

echo "Cleanup old versions"
ls -t *.gz | tail -n +2 | xargs rm -v --
